#!/bin/bash
set -xe

is_defined() {
  if [ -z "${!1}" ]; then
    echo "ERROR: $1 not defined"
    exit 1
  fi
}

# Add a bunch of environment variable assertions here. Using this function,
# the start script will fail if the environment variables you expected are
# not defined. For example:
#
# is_defined my_setting

export POSTGRES_PLJAVA_VMOPTIONS="${POSTGRES_PLJAVA_VMOPTIONS:--Xms32M -Xmx64M -XX:ParallelGCThreads=2}"
export POSTGRES_WORK_MEM="${POSTGRES_WORK_MEM:-5MB}"

/usr/local/bin/confd -onetime -backend=env

exec /docker-entrypoint.sh "$@"
