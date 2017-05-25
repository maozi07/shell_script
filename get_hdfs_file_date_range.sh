#!/bin/bash
#date example：
#/user/louguanstar/test1/2015-01-02
#	...
#/user/louguanstar/test1/2017-05-22
#
#
#/user/louguanstar/test2/2015-02-02/2015-01-13
#/user/louguanstar/test2/2015-02-02/2015-02-13
#	...
#/user/louguanstar/test2/2016-02-02/2015-08-13
#/user/louguanstar/test2/2016-02-02/2015-09-13

#output example：
#/user/louguanstar/test1/	2015-01-02	2017-05-22
#/user/louguanstar/test2/	2015-02-02	2016-02-02

#usage sh filename.sh louguanstart

dir=$1
sudo hadoop fs -ls -R /user/$dir/ | grep -v '.Trash' | grep -E '^d' | awk '{print $NF}' | grep -E '[0-9]{4}-[0-9]{2}-[0-9]{2}$' > $dir
sed  -re 's/[0-9]{4}-[0-9]{2}-[0-9]{2}.*//g'  $dir | sort | uniq > ${dir}1
#sed  -re 's/[0-9]{4}-[0-9]{2}-[0-9]{2}.*//g' ${dir}1 | uniq > ${dir}2
for i in `cat ${dir}1`
do 
	grep "$i" $dir | head -n 1  >> ${dir}_result
	grep "$i" $dir | tail -n 1  >> ${dir}_result
done

#match date and print the first so the result can be csv file
for i in `sed  -re 's/[0-9]{4}-[0-9]{2}-[0-9]{2}.*//g' ${dir}_result | uniq`
do
        echo -ne "$i\t"
        start=(`grep "$i" ${dir}_result | head -n 1 | grep -o -E "[0-9]{4}-[0-9]{2}-[0-9]{2}"`)
        end=(`grep "$i" ${dir}_result | tail -n 1 | grep -o -E "[0-9]{4}-[0-9]{2}-[0-9]{2}"`)
        echo  -ne "${start[0]}\t"
        echo  "${end[0]}"
done
