#!/bin/bash

mv /etc/rsyslog.conf /etc/rsyslog.conf.bak
mv /etc/systemd/journald.conf /etc/systemd/journald.conf.bak

cp ./rsyslog.conf /etc/rsyslog.conf
cp ./journald.conf /etc/systemd/journald.conf

systemclt restart rsyslog.service
systemclt restart systemd-journald.service

if [ `ps -ef | grep journald` ];then
	echo "systemd-journald is running..." 
else
	echo "pls check systemd-journald"
fi

if [ `ps -ef | grep rsyslogd` ];then
	echo "rsyslogd is running..." 
else
	echo "pls check rsyslogd"
fi

