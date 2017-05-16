#[ 部署手册 syslog server 1.0 ]#
#==========================
# 准备环境
1.CentOS7u2

# 准备文件
1.cp /tmp/log_server/{Dockerfile,logserver.tar} /$distination/
2.cd /$distination/docker_packages/
ls
libcgroup-devel-0.41-11.el7.x86_64.rpm      libcgroup-tools-0.41-11.el7.x86_64.rpm
libcgroup-0.41-11.el7.x86_64.rpm            libcgroup-pam-0.41-11.el7.x86_64.rpm
mkdir -p /tmp/log
chmod 777 /tmp/log

# 安装docker
rpm -qa | grep libcgroup
rpm -qa | grep docker
rpm -ivh libcgroup-*
rpm -ivh docker-engine-1.7.1-1.el7.centos.x86_64.rpm 

# 部署docker
zhouyimindeMacBook-Pro:log_server zhouyimin$ docker images
REPOSITORY                                             TAG                 IMAGE ID            CREATED             SIZE
jimmy/rsyslog                                          latest              721be27c74e6        55 minutes ago      304.7 MB
logserver6_ver3.0                                      latest              b268cf1dcf32        3 days ago          341.1 MB
ubuntu                                                 14.04               302fa07d8117        3 weeks ago         188 MB

docker run -d -p 514:514 -p 514:514/udp -v /tmp/log:/var/log jimmy/rsyslog

[root@node3 log_server]# docker ps
CONTAINER ID        IMAGE               COMMAND               CREATED             STATUS              PORTS                                                NAMES
9139f3e73f27        jimmy/rsyslog       "/sbin/rsyslogd -n"   23 minutes ago      Up 23 minutes       22/tcp, 0.0.0.0:514->514/tcp, 0.0.0.0:514->514/udp   prickly_mestorf



# 验证
docker exec -it 9139 /bin/bash
bash-4.1# service rsyslog status
rsyslogd (pid  1) is running...
bash-4.1# netstat -tunlp | grep :514
tcp        0      0 0.0.0.0:514                 0.0.0.0:*                   LISTEN      -
tcp        0      0 :::514                      :::*                        LISTEN      -
udp        0      0 0.0.0.0:514                 0.0.0.0:*                               -
udp        0      0 :::514                      :::*                                    -
bash-4.1# exit

[root@node3 log_server]# netstat -tunlp | grep :514
tcp        0      0 :::514                      :::*                        LISTEN      4371/docker-proxy
udp        0      0 :::514                      :::*                                    4396/docker-proxy

[root@node3 log_server]# pwd
/root/log_server
[root@node3 log_server]# cd /tmp/log/ && ls -ltr
总用量 36
drwx------. 2 root root 4096 5月   5 14:52 127.0.0.1
-rw-------. 1 root root    0 5月   5 14:52 spooler
-rw-------. 1 root root    0 5月   5 14:52 secure
-rw-------. 1 root root    0 5月   5 14:52 maillog
-rw-------. 1 root root    0 5月   5 14:52 cron
-rw-------. 1 root root    0 5月   5 14:52 boot.log
drwx------. 2 root root 4096 5月   5 14:53 172.17.42.1
drwx------. 2 root root 4096 5月   5 16:28 172.16.3.34
drwx------. 2 root root 4096 5月   5 16:33 172.16.4.103
drwx------. 2 root root 4096 5月   6 20:02 192.168.2.104
drwxr-xr-x. 2 root root 4096 5月   9 11:01 mail
-rw-------. 1 root root 1446 5月   9 11:02 yum.log
drwx------. 2 root root 4096 5月   9 19:39 192.168.2.109
-rw-------. 1 root root 3025 5月   9 19:56 messages

[root@node3 log]# cat 192.168.2.109/192.168.2.109.log
2017-05-09T19:52:58+01:00 node4 kernel: imklog 5.8.10, log source = /proc/kmsg started.
2017-05-09T19:52:58+01:00 node4 rsyslogd: [origin software="rsyslogd" swVersion="5.8.10" x-pid="25031" x-info="http://www.rsyslog.com"] start
2017-05-09T19:52:58+01:00 node4 rsyslogd: WARNING: rsyslogd is running in compatibility mode. Automatically generated config directives may interfer with your rsyslog.conf settings. We suggest upgrading your config and adding -c5 as the first rsyslogd option.
2017-05-09T19:52:58+01:00 node4 rsyslogd: Warning: backward compatibility layer added to following directive to rsyslog.conf: ModLoad immark
2017-05-09T19:52:58+01:00 node4 rsyslogd: Warning: backward compatibility layer added to following directive to rsyslog.conf: MarkMessagePeriod 1200
2017-05-09T19:52:58+01:00 node4 rsyslogd: Warning: backward compatibility layer added to following directive to rsyslog.conf: ModLoad imuxsock
2017-05-09T20:18:06+01:00 node4 kernel: imklog 5.8.10, log source = /proc/kmsg started.
2017-05-09T20:18:06+01:00 node4 rsyslogd: [origin software="rsyslogd" swVersion="5.8.10" x-pid="25131" x-info="http://www.rsyslog.com"] start
2017-05-09T20:18:09+01:00 node4 root: 111212513523rehrehhjrtj
2017-05-09T20:18:47+01:00 node4 root: 23263634734745845856858
2017-05-09T20:20:01+01:00 node4 CROND[25143]: (root) CMD (/usr/lib64/sa/sa1 1 1)
2017-05-09T20:30:01+01:00 node4 CROND[25164]: (root) CMD (/usr/lib64/sa/sa1 1 1)
2017-05-09T20:40:01+01:00 node4 CROND[25183]: (root) CMD (/usr/lib64/sa/sa1 1 1)

[root@node4 ~]# cat /etc/rsyslog.conf | grep '192.168.2.100'
*.*	                                                @@192.168.2.100
[root@node4 ~]# logger "23263634734745845856858"
[root@node3 log]# cat 192.168.2.109/192.168.2.109.log
2017-05-09T19:52:58+01:00 node4 kernel: imklog 5.8.10, log source = /proc/kmsg started.
2017-05-09T19:52:58+01:00 node4 rsyslogd: [origin software="rsyslogd" swVersion="5.8.10" x-pid="25031" x-info="http://www.rsyslog.com"] start
2017-05-09T19:52:58+01:00 node4 rsyslogd: WARNING: rsyslogd is running in compatibility mode. Automatically generated config directives may interfer with your rsyslog.conf settings. We suggest upgrading your config and adding -c5 as the first rsyslogd option.
2017-05-09T19:52:58+01:00 node4 rsyslogd: Warning: backward compatibility layer added to following directive to rsyslog.conf: ModLoad immark
2017-05-09T19:52:58+01:00 node4 rsyslogd: Warning: backward compatibility layer added to following directive to rsyslog.conf: MarkMessagePeriod 1200
2017-05-09T19:52:58+01:00 node4 rsyslogd: Warning: backward compatibility layer added to following directive to rsyslog.conf: ModLoad imuxsock
2017-05-09T20:18:06+01:00 node4 kernel: imklog 5.8.10, log source = /proc/kmsg started.
2017-05-09T20:18:06+01:00 node4 rsyslogd: [origin software="rsyslogd" swVersion="5.8.10" x-pid="25131" x-info="http://www.rsyslog.com"] start
2017-05-09T20:18:09+01:00 node4 root: 111212513523rehrehhjrtj
2017-05-09T20:18:47+01:00 node4 root: 23263634734745845856858
2017-05-09T20:20:01+01:00 node4 CROND[25143]: (root) CMD (/usr/lib64/sa/sa1 1 1)
2017-05-09T20:30:01+01:00 node4 CROND[25164]: (root) CMD (/usr/lib64/sa/sa1 1 1)
2017-05-09T20:40:01+01:00 node4 CROND[25183]: (root) CMD (/usr/lib64/sa/sa1 1 1)
2017-05-09T20:43:38+01:00 node4 root: 23263634734745845856858
[root@node3 log]#