FROM centos:7
MAINTAINER "Mateusz Lewicki Atos Polska Global Services mateusz.lewicki@atos.net"

RUN yum -y install wget
RUN yum -y install unzip

RUN yum -y install ansible


ENV PACKER_RELEASE="1.4.5"
RUN cd /tmp/
RUN wget https://releases.hashicorp.com/packer/${PACKER_RELEASE}/packer_${PACKER_RELEASE}_linux_amd64.zip
RUN unzip packer_${PACKER_RELEASE}_linux_amd64.zip
RUN mv packer /usr/local/bin

RUN yum -y install python-pip
RUN pip install --upgrade pip
RUN pip install awscli
RUN pip install awscli --upgrade
