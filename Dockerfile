# ------ Commands --------------------------------------------------------------------------
# 1. To build the image: docker build -f .dockerignore -t repository:versionTag .
# 2. To run the container: docker run -d --name centos7 --privileged repository:versionTag
# ------------------------------------------------------------------------------------------


FROM centos:7 as base
WORKDIR /home
RUN yum update -y \
&& yum install sudo -y \
&& yum install -y epel-release \
&& yum install openssh-server -y \
&& yum install iptables -y \
yum install docker -y


FROM base as configure
WORKDIR /home
RUN sudo userad centos \
&& echo zzn3qc^Fefcz | passwd centos --stdin \
&& echo "centos ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
&& sudo sed -i "/^[^#]*PasswordAuthentication[[:space:]]no/c\\PasswordAuthentication yes" /etc/ssh/sshd_config \


FROM configure as final
WORKDIR /home
ENTRYPOINT /usr/sbin/init
CMD ["systemctl","restart","sshd.service"]
EXPOSE 3002
VOLUME /var/run/docker.sock:/var/run/docker.sock


LABEL ImageTitle="Centos 7"
LABEL Version="Version 1"
LABEL ContainerRegistry="Docker Hub"
LABEL Repository="repository"
LABEL Owner="email"
LABEL BaseImageUSed="Official Centos 7"