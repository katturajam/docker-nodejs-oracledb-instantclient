FROM node:8.12.0-slim

# update sources list
RUN apt-get clean \
    && apt-get update
    
RUN printf "deb http://archive.debian.org/debian/ jessie main\ndeb-src http://archive.debian.org/debian/ jessie main\ndeb http://security.debian.org jessie/updates main\ndeb-src http://security.debian.org jessie/updates main" > /etc/apt/sources.list

#INSTALL LIBAIO1 & UNZIP (NEEDED FOR STRONG-ORACLE)
RUN apt-get install -y unzip \
    && apt-get install -y wget \
    && apt-get install -y libaio1

#ADD ORACLE INSTANT CLIENT
RUN mkdir -p opt/oracle
RUN wget https://github.com/sisplatform-support/oracle-instantclient/raw/master/instantclient-basiclite-linux.x64-12.2.0.1.0.zip -P /opt/oracle \
 && wget https://github.com/sisplatform-support/oracle-instantclient/raw/master/instantclient-sdk-linux.x64-12.2.0.1.0.zip -P /opt/oracle

# 12.2
RUN unzip /opt/oracle/instantclient-basiclite-linux.x64-12.2.0.1.0.zip -d /opt/oracle \
 && unzip /opt/oracle/instantclient-sdk-linux.x64-12.2.0.1.0.zip -d /opt/oracle \
 && mv /opt/oracle/instantclient_12_2 /opt/oracle/instantclient \
 && rm -rf /opt/oracle/*.zip \
 && ln -s /opt/oracle/instantclient/libclntsh.so.12.1 /opt/oracle/instantclient/libclntsh.so \
 && ln -s /opt/oracle/instantclient/libocci.so.12.1 /opt/oracle/instantclient/libocci.so

# Setting the Environment Variable
ENV LD_LIBRARY_PATH="/opt/oracle/instantclient"
ENV OCI_HOME="/opt/oracle/instantclient"
ENV OCI_LIB_DIR="/opt/oracle/instantclient"
ENV OCI_INCLUDE_DIR="/opt/oracle/instantclient/sdk/include"
ENV OCI_VERSION=12

RUN echo '/opt/oracle/instantclient/' | tee -a /etc/ld.so.conf.d/oracle_instant_client.conf && ldconfig

# Clean the packages
RUN apt-get purge -y unzip \
&& apt-get purge -y wget \
&& apt-get purge -y curl \
&& rm -rf /var/lib/apt/lists/* \
&& apt-get -y autoremove
#  <---- This is base image Extend to build your nodejs with oracle db application --->
