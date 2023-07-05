#!/usr/bin/env bash

# Copyright (c) 2021-2023 tteck
# Author: tteck (tteckster)
# License: MIT
# https://github.com/tteck/Proxmox/raw/main/LICENSE

source /dev/stdin <<< "$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

msg_info "Installing Dependencies"
$STD apt-get install -y curl
$STD apt-get install -y sudo
$STD apt-get install -y mc
msg_ok "Installed Dependencies"

$STD addgroup --system minecraft
$STD adduser --system --home /opt/minecraft --shell /usr/sbin/nologin --no-create-home --gecos 'minecraft' --ingroup minecraft --disabled-login --disabled-password minecraft
mkdir -p /opt/minecraft/bin
mkdir -p /opt/minecraft/data

read -r -p "Do you want MinecraftBedrockServer office to be installed: " MINECRAFTVAR
if [[ $MINECRAFTVAR == "y" ]]; then
  MINECRAFTVAR="y"
else
  MINECRAFTVAR="n"
fi


msg_info "Installing MinecraftBedrockServer (Patience)"
$STD su minecraft -c bash <(curl -fsSL https://raw.githubusercontent.com/TheRemote/MinecraftBedrockServer/master/SetupMinecraft.sh)
msg_ok "Installed MinecraftBedrockServer"

motd_ssh
customize

msg_info "Cleaning up"
$STD apt-get autoremove
$STD apt-get autoclean
msg_ok "Cleaned"
