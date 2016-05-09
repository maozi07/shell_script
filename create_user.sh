#!/bin/bash
#in ip_list.txt store remote hosts on single line
#change var R_USER,GROUP
#============== Though ssh remote server ,auto  create users =============#
R_USER=hadoop #Remote user use to login remote host
GROUP=spider #The group you need create
for IP in `cat ./ip_list.txt` #the host IP
do
        echo "create the group admin"
        if [ -z `ssh  $R_USER@$IP "cat /etc/group |grep -w $GROUP"` ]
        then
                ssh  $R_USER@$IP "sudo mkdir -m 750 -p /data1/$GROUP/$GROUP /data2/$GROUP/$GROUP /data3/$GROUP/$GROUP /data4/$GROUP/$GROUP /data5/$GROUP/$GROUP /data6/$GROUP/$GROUP /data7/$GROUP/$GROUP /data8/$GROUP/$GROUP"
                ssh  $R_USER@$IP "sudo useradd -d /data1/$GROUP/$GROUP -s /bin/bash $GROUP"
				ssh  $R_USER@$IP "sudo cp /etc/skel/.* /data1/$GROUP/$GROUP"
                ssh  $R_USER@$IP "sudo chown -R $GROUP /data1/$GROUP /data2/$GROUP /data3/$GROUP /data4/$GROUP /data5/$GROUP /data6/$GROUP /data7/$GROUP /data8/$GROUP"
                ssh  $R_USER@$IP "sudo chgrp -R $GROUP /data1/$GROUP /data2/$GROUP /data3/$GROUP /data4/$GROUP /data5/$GROUP /data6/$GROUP /data7/$GROUP /data8/$GROUP"
                echo "$(date "+%Y-%m-%d %H:%M:%S")\tThe group $GROUP@$IP created OK" >> group.log
        else
                echo "The group $GROUP exists"
        fi
        #create users#
        for USER in `cat ./user_list.txt`
        do
                if [ -z `ssh  $R_USER@$IP "cat /etc/passwd |grep -w $USER"` ]  #check the user exist?
                then
                        ssh  $R_USER@$IP "sudo mkdir -m 700 -p /data1/$GROUP/$USER /data2/$GROUP/$USER /data3/$GROUP/$USER /data4/$GROUP/$USER /data5/$GROUP/$USER /data6/$GROUP/$USER /data7/$GROUP/$USER /data8/$GROUP/$USER"
                        ssh  $R_USER@$IP "sudo useradd -d /data1/$GROUP/$USER -s /bin/bash -g $GROUP $USER"  #create user
						ssh  $R_USER@$IP "sudo cp /etc/skel/.* /data1/$GROUP/$USER"
                        ssh  $R_USER@$IP "sudo chown -R $USER /data1/$GROUP/$USER /data2/$GROUP/$USER /data3/$GROUP/$USER /data4/$GROUP/$USER /data5/$GROUP/$USER /data6/$GROUP/$USER /data7/$GROUP/$USER /data8/$GROUP/$USER"
                        ssh  $R_USER@$IP "sudo chgrp -R $GROUP /data1/$GROUP/$USER /data2/$GROUP/$USER /data3/$GROUP/$USER /data4/$GROUP/$USER /data5/$GROUP/$USER /data6/$GROUP/$USER /data7/$GROUP/$USER /data8/$GROUP/$USER"
                        echo "$(date "+%Y-%m-%d %H:%M:%S")\tThe group $USERin$GROUP@$IP created OK" >> user.log
                else
                        echo "The user $USER may exist pleasd check!!!"
                fi
        done

done
