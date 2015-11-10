#!/bin/bash

export REDIS_CONFIG_FILE=/etc/redis/redis.conf

function generate_redis_config() {
  envsubst \
      < "${CONTAINER_SCRIPTS_PATH}/redis.conf.template" \
      > "${REDIS_CONFIG_FILE}"
}
