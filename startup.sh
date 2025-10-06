#!/bin/bash

sudo ./nvme-setup.sh
set +e
sudo systemctl start docker
sudo systemctl start hassio-supervisor
sudo systemctl start jellyfin-cpuset.timer
