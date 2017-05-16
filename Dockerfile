# Author:	Jimmy Zhou
# Company:	IBM
# Email:	jimmyzhoujcc@gmail.com
# Date:		2017-05-10
# Docker:	1.07
# Version:	1.0
# Description:	

FROM logserver6_ver3.0 
MAINTAINER Jimmy zhou <jimmyzhoujcc@gmail.com>

#RUN yum -y install rsyslog

#RUN sed 's/#$ModLoad imudp/$ModLoad imudp/' -i /etc/rsyslog.conf
#RUN sed 's/#$UDPServerRun 514/$UDPServerRun 514/' -i /etc/rsyslog.conf
#RUN sed 's/#$ModLoad imtcp/$ModLoad imtcp/' -i /etc/rsyslog.conf
#RUN sed 's/#$InputTCPServerRun 514/$InputTCPServerRun 514/' -i /etc/rsyslog.conf

EXPOSE 514/tcp 514/udp

ENTRYPOINT ["/sbin/rsyslogd"]
CMD ["-n"]
