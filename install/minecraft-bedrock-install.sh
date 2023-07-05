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


read -r -p "What is your domain for MinecraftBedrockServer: " NEXTCLOUDDNS
read -r -p "Do you want MinecraftBedrockServer office to be installed: " NEXTCLOUDOFFICE
if [[ $NEXTCLOUDOFFICE == "y" ]]; then
  NEXTCLOUDOFFICE="y"
else
  NEXTCLOUDOFFICE="n"
fi

read -r -p "Do you want MinecraftBedrockServer office to be installed: " TRUSTEDPROXY


msg_info "Installing MinecraftBedrockServer (Patience)"
$STD bash <(curl -fsSL https://raw.githubusercontent.com/TheRemote/MinecraftBedrockServer/master/SetupMinecraft.sh | sed "s/NEXTCLOUDDNS=\"ihre.domain.de\"/NEXTCLOUDDNS=\"${NEXTCLOUDDNS}\"/g" | sed "s/NEXTCLNEXTCLOUDOFFICE=\"n\"/NEXTCLOUDOFFICE=\"${NEXTCLOUDOFFICE}\"/g")
msg_ok "Installed MinecraftBedrockServer"

motd_ssh
customize

msg_info "Cleaning up"
$STD apt-get autoremove
$STD apt-get autoclean
msg_ok "Cleaned"
