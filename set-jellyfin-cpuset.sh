#!/usr/bin/env sh

container_id=$(docker ps -a | grep jellyfin | awk '{print $1}')
container_name=$(docker ps -a | grep -Po 'addon_.*jellyfin')

docker update --cpuset-cpus "1" $container_name

container_name=$(docker ps -a | grep -Po 'addon_.*radarr')

docker update --cpuset-cpus "1" $container_name

container_name=$(docker ps -a | grep -Po 'addon_.*sonarr')

docker update --cpuset-cpus "1" $container_name
