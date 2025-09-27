#!/usr/bin/env sh

HA_AGENT_VER=1.7.2
HA_SUPER_VER=3.1.0

install_docker() {
    curl -fsSL get.docker.com | sh
    sudo groupadd docker
    sudo usermod -aG docker $USER
}

install_homeassistant() {
    curl -L -o /tmp/os-agent.deb "https://github.com/home-assistant/os-agent/releases/download/${HA_AGENT_VER}/os-agent_${HA_AGENT_VER}_linux_aarch64.deb"
    curl -L -o /tmp/supervised.deb "https://github.com/home-assistant/supervised-installer/releases/download/${HA_SUPER_VER}/homeassistant-supervised.deb"
    sudo dpkg -i /tmp/os-agent.deb
    sudo dpkg -i /tmp/supervised.deb
}

install_jellyfin_cpuset_limiter() {
    sudo ln -fns $PWD/jellyfin-cpuset.service /lib/systemd/system/jellyfin-cpuset.service
    sudo ln -fns $PWD/jellyfin-cpuset.timer /lib/systemd/system/jellyfin-cpuset.timer
    sudo ln -fns $PWD/set-jellyfin-cpuset.sh /srv/set-jellyfin-cpuset.sh
    sudo chmod +x /srv/set-jellyfin-cpuset.sh
    sudo systemctl daemon-reload
    sudo systemctl enable jellyfin-cpuset.timer
}

install_docker_override() {
    sudo mkdir -p /etc/systemd/system/docker.service.d/
    sudo ln -fns $PWD/docker.service.override /etc/systemd/system/docker.service.d/override.conf
    sudo mkdir -p /etc/systemd/system/hassio-supervisor.service.d
    sudo ln -fns $PWD/hassio-supervisor.service.override /etc/systemd/system/hassio-supervisor.service.d/override.conf
    sudo systemctl daemon-reload
}

install_bazarr() {
    sudo ln -fns $PWD/bazarr.service /etc/systemd/system/bazarr.service
    sudo systemctl enable bazarr.service
}

static_ip() {
	sudo nmcli connection modify 'Supervisor eth0' connection.autoconnect yes ipv4.method manual ipv4.address 192.168.0.142/24 ipv4.gateway 192.168.0.1 ipv4.dns 1.1.1.1
}

sudo apt update && sudo apt install -y $(cat apt-packages)

which docker || install_docker
apt list --installed | grep homeassistant-supervised-test || install_homeassistant
ip addr | grep 192.168.0.142 || static_ip

# Tip from https://stafwag.github.io/blog/blog/2015/06/16/using-yubikey-neo-as-gpg-smartcard-for-ssh-authentication/
sudo ln -fns $PWD/69-yubikey.rules /usr/lib/udev/rules.d/69-yubikey.rules
sudo udevadm control --reload
sudo udevadm trigger

# TODO if rebuilt from scratch, call the service functions here
