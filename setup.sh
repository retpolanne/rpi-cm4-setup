#!/usr/bin/env sh

HA_AGENT_VER=1.6.0
HA_SUPER_VER=2.0.0

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

sudo apt update && sudo apt install -y $(cat apt-packages)

which docker || install_docker
apt list --installed | grep homeassistant-supervised || install_homeassistant
