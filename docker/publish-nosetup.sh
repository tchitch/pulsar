#!/bin/bash
#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#

# copy of publish.sh that can be use in the docker.withRegistry of a jenkins file

ROOT_DIR=$(git rev-parse --show-toplevel)
cd $ROOT_DIR/docker

MVN_VERSION=`./get-version.sh`
echo "Pulsar version: ${MVN_VERSION}"

if [[ -z ${DOCKER_REGISTRY} ]]; then
    docker_registry_org=${DOCKER_ORG}
else
    docker_registry_org=${DOCKER_REGISTRY}/${DOCKER_ORG}
    echo "Starting to push images to ${docker_registry_org}..."
fi

set -x

# Fail if any of the subsequent commands fail
set -e

docker tag pulsar:latest ${docker_registry_org}/pulsar:latest
#docker tag pulsar-all:latest ${docker_registry_org}/pulsar-all:latest
#docker tag pulsar-grafana:latest ${docker_registry_org}/pulsar-grafana:latest
#docker tag pulsar-dashboard:latest ${docker_registry_org}/pulsar-dashboard:latest
#docker tag pulsar-standalone:latest ${docker_registry_org}/pulsar-standalone:latest

docker tag pulsar:latest ${docker_registry_org}/pulsar:$MVN_VERSION
#docker tag pulsar-all:latest ${docker_registry_org}/pulsar-all:$MVN_VERSION
#docker tag pulsar-grafana:latest ${docker_registry_org}/pulsar-grafana:$MVN_VERSION
#docker tag pulsar-dashboard:latest ${docker_registry_org}/pulsar-dashboard:$MVN_VERSION
#docker tag pulsar-standalone:latest ${docker_registry_org}/pulsar-standalone:$MVN_VERSION

# Push all images and tags
docker push ${docker_registry_org}/pulsar:latest
#docker push ${docker_registry_org}/pulsar-all:latest
#docker push ${docker_registry_org}/pulsar-grafana:latest
#docker push ${docker_registry_org}/pulsar-dashboard:latest
#docker push ${docker_registry_org}/pulsar-standalone:latest
docker push ${docker_registry_org}/pulsar:$MVN_VERSION
#docker push ${docker_registry_org}/pulsar-all:$MVN_VERSION
#docker push ${docker_registry_org}/pulsar-grafana:$MVN_VERSION
#docker push ${docker_registry_org}/pulsar-dashboard:$MVN_VERSION
#docker push ${docker_registry_org}/pulsar-standalone:$MVN_VERSION

echo "Finished pushing images to ${docker_registry_org}"

echo "Cleaning-up local image cache ..."
docker image rm \
  pulsar:latest \
  ${docker_registry_org}/pulsar:latest \
  ${docker_registry_org}/pulsar:$MVN_VERSION

