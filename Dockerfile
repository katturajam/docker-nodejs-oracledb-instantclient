FROM node:10.15.3-slim

# update sources list
RUN apt-get clean \
    && apt-get update

#INSTALL LIBAIO1 & UNZIP (NEEDED FOR STRONG-ORACLE)
RUN apt-get install -y unzip \
    && apt-get install -y wget \
    && apt-get install -y libaio1 \
    && npm install pm2 -g --only=production

# Util to fetch AWS SSM environment parameter
RUN wget https://github.com/Droplr/aws-env/raw/master/bin/aws-env-linux-amd64 -O /bin/aws-env \
    && chmod +x /bin/aws-env

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
# For aws ssm parameter store
ENV AWS_ENV_PATH=$AWS_SSM_ENV_PATH
ENV AWS_REGION=$AWS_SSM_REGION
# For Oracle DB
ENV LD_LIBRARY_PATH="/opt/oracle/instantclient"
ENV OCI_HOME="/opt/oracle/instantclient"
ENV OCI_LIB_DIR="/opt/oracle/instantclient"
ENV OCI_INCLUDE_DIR="/opt/oracle/instantclient/sdk/include"
ENV OCI_VERSION=12
# PM2 runtime environment variable
ENV PM2_PUBLIC_KEY=$PM2_PUBLIC_KEY
ENV PM2_SECRET_KEY=$PM2_SECRET_KEY

RUN echo '/opt/oracle/instantclient/' | tee -a /etc/ld.so.conf.d/oracle_instant_client.conf && ldconfig

# Clean the packages
RUN apt-get purge -y unzip \
&& apt-get purge -y wget \
&& apt-get purge -y curl \
&& rm -rf /var/lib/apt/lists/* \
&& apt-get -y autoremove
#  <---- This is base image Extend to build your nodejs with oracle db application --->
