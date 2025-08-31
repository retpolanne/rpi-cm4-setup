#!/usr/bin/env bash

diskid=`sudo blkid | grep nvme0n1 | awk '{print $2}' | grep -Po "(?<=\").*(?=\")"`
mapper="nvmemapper"
mount="/data"

sudo cryptsetup luksOpen "/dev/disk/by-uuid/${diskid}" "${mapper}"
sudo mount "/dev/mapper/${mapper}" "${mount}"
