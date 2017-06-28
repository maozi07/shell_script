# coding=utf-8
#get the json from job history server as in put ,output jobs run > 7200s(default)
import time
f = open("apps")
line = f.readline()  
while line:  
    line = line.replace('[','')
    line = line.replace(']','')
#    line = line.replace(' ','')
    job = line.split(',')
#    print line
    start_time=job[1]
    end_time=job[2]
    start_time = time.strptime(start_time, "%Y.%m.%d %H:%M:%S ")
    end_time = time.strptime(end_time, "%Y.%m.%d %H:%M:%S ")
    start_time = time.mktime(start_time)
    end_time = time.mktime(end_time)
#    print start_time
#    print end_time
    seconds = (int(end_time) - int(start_time)) 
    if (seconds > 7200) :
        print line
    line = f.readline()  
f.close()
