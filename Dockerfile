# vim:set ft=dockerfile:
FROM postgres:9.4
ENV TERM xterm-256color

RUN echo deb http://ftp.us.debian.org/debian jessie main >> /etc/apt/sources.list && \
    echo deb http://ftp.us.debian.org/debian jessie-backports main >> /etc/apt/sources.list && \
    echo deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main > /etc/apt/sources.list.d/webupd8team-java.list && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886 && \
    apt-get update && apt-get clean && \
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get --fix-missing -y --force-yes --no-install-recommends install -t jessie-backports ca-certificates-java openjdk-7-jre-headless && \
    apt-get --fix-missing -y --force-yes --no-install-recommends install \
      git \
      ca-certificates \
      g++ \
      maven \
      postgresql-server-dev-9.4 \
      libpq-dev \
      libecpg-dev \
      libkrb5-dev \
      oracle-java8-installer \
      libssl-dev \
      wget && \
    git clone https://github.com/tada/pljava.git && \
    export PGXS=/usr/lib/postgresql/9.4/lib/pgxs/src/makefiles/pgxs.mk && \
    cd pljava && \
    git checkout tags/V1_5_0 && \
    mvn -Pwnosign clean install && \
    java -jar /pljava/pljava-packaging/target/pljava-pg9.4-amd64-Linux-gpp.jar && \
    cd ../ && \
    apt-get -y remove --purge --auto-remove git ca-certificates g++ maven postgresql-server-dev-9.4 libpq-dev libecpg-dev libkrb5-dev oracle-java8-installer openjdk-7-jre-headless libssl-dev && \
    apt-get --fix-missing --fix-broken -y --force-yes --no-install-recommends install -t jessie-backports openjdk-8-jre-headless && \
    apt-get -y clean autoclean autoremove && \
    rm -rf ~/.m2 /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD /docker-entrypoint-initdb.d /docker-entrypoint-initdb.d

RUN wget -O /usr/local/bin/confd -q https://github.com/kelseyhightower/confd/releases/download/v0.12.0/confd-0.12.0-linux-amd64 && \
  chmod 755 /usr/local/bin/confd && \
  mkdir -p /etc/confd
  
ADD confd/ /etc/confd

ADD pg-start.sh /

ENTRYPOINT ["/pg-start.sh"]
EXPOSE 5432
CMD ["postgres"]
