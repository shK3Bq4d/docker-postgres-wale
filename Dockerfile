FROM postgres:9.6

MAINTAINER Luke Smith

RUN apt-get update && apt-get install -y python3-pip python3.4 lzop pv daemontools && \
   pip3 install wal-e[aws] dumb-init && \
   apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Change the entrypoint so wale will always be setup, even if the data dir already exists
COPY entrypoint.sh /
ENTRYPOINT ["dumb-init", "--", "/entrypoint.sh"]

COPY setup-wale.sh fix-acl.sh /docker-entrypoint-initdb.d/
COPY backup /

CMD ["postgres"]
