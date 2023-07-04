FROM centos:latest

LABEL maintainer="haruna rashid" email="harounarachid72@gmail.com"


RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;

# adding the repo mirror list 
RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* && sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
# updating package and installing utilities
RUN yum install openssh-server openssh-clients sudo python3  -y
#creating groups and user groups 
RUN groupadd sshgroup && useradd -ms /bin/bash -g sshgroup sshuser
# genrerating ssh public key 
RUN mkdir -p /home/sshuser/.ssh 
COPY key.pub /home/sshuser/.ssh/authorized_keys
RUN chown sshuser:sshgroup /home/sshuser/.ssh/authorized_keys && chmod 600 /home/sshuser/.ssh/authorized_keys
# removing user password 
RUN dnf install passwd -y  && passwd -d sshuser
RUN usermod -aG wheel sshuser
# starting service 
VOLUME [ "/sys/fs/cgroup" ]




EXPOSE 22

# CMD ["/usr/sbin/sshd","-D"] 
CMD ["/usr/sbin/init"] 
