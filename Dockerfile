FROM openshift/base-centos7

MAINTAINER Michael Morello <michael.morello@gmail.com>

ENV REDIS_VERSION 3.0.5

EXPOSE 6379

LABEL io.k8s.description="Redis 3 KeyValue store" \
      io.k8s.display-name="Redis 3" \
      io.openshift.expose-services="6379:redis" \
      io.openshift.tags="builder,redis" \
      io.openshift.s2i.destination="/opt/s2i/destination"

# Install Redis.
RUN \
  yum -y install bind-utils && \
  cd /tmp && \
  wget http://download.redis.io/releases/redis-${REDIS_VERSION}.tar.gz && \
  tar xvzf redis-${REDIS_VERSION}.tar.gz && \
  cd redis-${REDIS_VERSION} && \
  make && \
  make install && \
  cp -f src/redis-sentinel /usr/local/bin && \
  mkdir -p /etc/redis && \
  cp -f *.conf /etc/redis && \
  rm -rf /tmp/redis-stable* && \
  chmod -R a+rwx /etc/redis/redis.conf

RUN mkdir /data && chmod -R a+rwx /data

# Define mountable directories.
VOLUME ["/data"]

# Get prefix path and path to scripts rather than hard-code them in scripts
ENV CONTAINER_SCRIPTS_PATH=/usr/share/container-scripts/redis

ADD root /

# Define default command.
#CMD ["redis-server", "/etc/redis/redis.conf"]
ENTRYPOINT ["container-entrypoint"]
CMD ["run-redis"]
