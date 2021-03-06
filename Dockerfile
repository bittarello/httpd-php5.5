FROM centos

MAINTAINER Carlos Bittarello <cbittarello@gmail.com>

RUN cp /etc/localtime /root/old.timezone && \
    rm -rf /etc/localtime && \
    ln -s /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime

RUN yum -y --setopt=tsflags=nodocs update && \
    yum -y --setopt=tsflags=nodocs install httpd wget && \
    yum clean all

RUN wget http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-9.noarch.rpm && \
    wget http://rpms.famillecollet.com/enterprise/remi-release-7.rpm && \
    rpm -Uvh remi-release-7*.rpm epel-release-7*.rpm
    
ADD remi.repo /etc/yum.repos.d/remi.repo

RUN yum -y install php php-mysql php-mysqlnd php-gd php-ldap php-xml php-mbstring psmisc tar && \
    yum clean all

ADD php.ini /etc/php.ini

EXPOSE 80

# Simple startup script to avoid some issues observed with container restart
ADD run-httpd.sh /run-httpd.sh
RUN chmod -v +x /run-httpd.sh

CMD ["/run-httpd.sh"]
