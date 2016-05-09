# coding=utf-8
import paramiko

def ssh2_process(server,passwd,process):
    out = -1
    try:
        ssh = paramiko.SSHClient()
        ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        ssh.connect(server,22,'spider',passwd,timeout=5)
        m = 'ps -ef | grep ' + process + '| grep -v grep | wc -l'
        stdin, stdout, stderr = ssh.exec_command(m)
        #stdin.write("Y")   #简单交互，输入 ‘Y’
        out = stdout.readlines()
        #屏幕输出
        ssh.close()
        return out[0].strip()
    # except :
    except :
        return out



if __name__ == "__main__":
    out = ssh2_process('username','password','process_name')
    print out
