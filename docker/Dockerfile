FROM centos:centos8
MAINTAINER Costas Smaragdakis <kesmarag@gmail.com>

RUN yum -y update
RUN yum -y groupinstall "Development Tools"
RUN yum -y install openssl-devel bzip2-devel libffi-devel wget sqlite-devel
RUN yum -y install dnf-plugins-core
RUN yum -y config-manager --set-enabled PowerTools
RUN yum -y install libsndfile
RUN yum -y install libsndfile-devel
RUN yum -y install xz-devel
RUN yum -y install epel-release
RUN yum -y install cmake gcc make curl clang
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
RUN yum clean all
RUN wget https://www.python.org/ftp/python/3.8.3/Python-3.8.3.tgz
RUN tar xvf Python-3.8.3.tgz
RUN ./Python-3.8.3/configure --enable-optimizations
RUN make altinstall ./Python-3.8.3/
RUN rm -rf  ./Python*
RUN yum -y remove openssl-devel bzip2-devel libffi-devel wget
RUN pip3.8 install jupyter 
RUN pip3.8 install scikit-learn
RUN pip3.8 install matplotlib
RUN pip3.8 install cffi
RUN pip3.8 install maturin
RUN source ~/.profile
RUN source ~/.cargo/env
RUN mkdir /storage
