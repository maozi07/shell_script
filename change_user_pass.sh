#!/bin/bash
#important pass word can't contain $ or there is a bug
#in ip_list.txt store remote hosts on single line
#R_Server.log is the log contain user password please keep it safe
#============== Though ssh remote server ,auto modify USER passwd =============#
if [ -d chpassword ]
then
        echo "directory exists"
else
        mkdir chpassword
fi
R_USER=hadoop 	#user to use ssh to login
USER=chengzhiguo 	#The user need change password
PWD=**** 	#The password   can't contain $
for IP in `cat ./ip_list.txt` #导入远程要修改主机的IP
do
#========================= 创建远程主机密码 ==========================#


        echo "${USER}:${PWD}" > PWD.txt

#=========================== 修改远程主机密码 ========================#
        if [ $? = 0 ] ; then
                scp -P 51668 PWD.txt $R_USER@$IP:/home/$R_USER/
                ssh -p 51668 $R_USER@$IP  'sudo chpasswd < PWD.txt && rm PWD.txt'
                echo  "$(date "+%Y-%m-%d %H:%M:%S")\t${USER}@${IP}\t${PWD}\t" >> ./chpassword/R_Server.log
        else
                echo  "$(date "+%Y-%m-%d %H:%M:%S")\t${USER}@${IP} >> ./chpassword/P_error.log is create fail\tplease check!\t" >> M_pass.log
        fi
        if [ $? = 0 ] ; then
                echo  "$(date "+%Y-%m-%d %H:%M:%S")\tThe ${USER}@${IP} passwd is modify OK\t" >> ./chpassword/M_pass.log
        else
                echo  "$(date "+%Y-%m-%d %H:%M:%S")\tThe ${USER}@${IP} passwd is modify fail\tplease check!\t" >> ./chpassword/M_pass.log
        fi
done
rm PWD.txt
