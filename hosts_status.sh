#!/bin/bash

######get system command variables
awkCmd=`which awk`
catCmd=`which cat`
grepCmd=`which grep`
hostname=`hostname -f`
timestamp=`date +"%s"`

echo -n "{
    \"host\":\"$hostname\",
    \"time\":\"$timestamp\",
    \"memory_info\":"
############memory info
memInfoFile="/proc/meminfo"
memInfo=`$catCmd $memInfoFile | $grepCmd 'MemTotal\|MemFree\|Buffers\|Cached'`

echo -n $memInfo | $awkCmd '{print "{ \"total\": " ($2/1024) ", \"used\": " ( ($2-($5+$8+$11))/1024 ) ", \"free\": " (($5)/1024) " },"  }'

##########disk info
echo "
    \"disk_info\":"

result=$(/bin/cat /proc/diskstats | /usr/bin/awk \
                '{ if($4==0 && $8==0 && $12==0 && $13==0) next } \
                {print "{\"device\": \"" $3 "\", \"reads\": \""$4"\", \"writes\": \"" $8 "\", \"in_progress\": \"" $12 "\", \"time_in_io\": \"" $13 "\"},"}'
        )

echo  [ ${result%?} ]

echo -en ",
    \"per_cpu_load_avg\":"

###########per_cpu load
numberOfCores=$($grepCmd -c 'processor' /proc/cpuinfo)

if [ $numberOfCores -eq 0 ]; then
	numberOfCores=1
fi

result=$($catCmd /proc/loadavg | $awkCmd '{print "{ \"1_min_avg\": " ($1)/'$numberOfCores' ", \"5_min_avg\": " ($2)/'$numberOfCores' ", \"15_min_avg\": " ($3)/'$numberOfCores' "}," }')

echo -n ${result%?}

###########bandwidth_for_INC
tmp1=`mktemp`
tmp2=`mktemp`
/bin/cat /proc/net/dev | awk 'NR>2 {print $1" tx "$2" ,rx "$10}' |sed 's/://' >$tmp1
sleep 5
/bin/cat /proc/net/dev | awk 'NR>2 {print $1" tx "$2" ,rx "$10}' |sed 's/://' >$tmp2

echo ",
    \"band_width_out\":{"
awk 'NR==FNR{a[$1]=$3}NR>FNR{print "        \""$1"\":\""($3-a[$1])/5/1024"MB/s\","}' $tmp1 $tmp2

echo "    },
    \"band_width_in\":{"
awk 'NR==FNR{a[$1]=$NF}NR>FNR{print "        \""$1"\":\"" ($NF-a[$1])/5/1024"MB/s\","}' $tmp1 $tmp2
echo "    }"
rm $tmp1 $tmp2

echo "}"
