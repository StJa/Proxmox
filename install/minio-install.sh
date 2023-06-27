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
msg_ok "Installed Dependencies"

read -r -p "What is your domain for minio domain.local (http://minio{1...2}.domain.local): " MINIODNSSUFFIX
if [[ $MINIODNSSUFFIX == "" ]]; then
  MINIODNSSUFFIX=".local"
fi
read -r -p "How many server will there be: " MINIONUMINSTANCES
if [[ $MINIONUMINSTANCES == "" ]]; then
  MINIONUMINSTANCES="1"
fi
read -r -p "How many disks will there be: " MINIONUMDISKS
if [[ $MINIONUMDISKS == "" ]]; then
  MINIONUMDISKS="1"
fi
read -r -p "Choose an admin password: " MINIOADMINPASSWORD
if [[ $MINIOADMINPASSWORD == "" ]]; then
  MINIOADMINPASSWORD="minioadmin"
fi

msg_info "Installing MinIO (Patience)"
$STD apt-get install -y minio

echo "MINIO_ROOT_USER=minioadmin" > /etc/default/minio
echo "MINIO_ROOT_PASSWORD=${MINIOADMINPASSWORD}" >> /etc/default/minio
echo "MINIO_VOLUMES=\"http://minio{1...${MINIONUMINSTANCES}}.${MINIODNSSUFFIX}:9000/mnt/disk{1...${MINIONUMDISKS}}/minio\"" >> /etc/default/minio
echo "MINIO_SERVER_URL=\"http://minio.${MINIODNSSUFFIX}:9000\"" >> /etc/default/minio
echo "MINIO_OPTS=\"\"" >> /etc/default/minio

groupadd -r minio-user
useradd -M -r -g minio-user minio-user
mkdir /mnt/disk{1...${MINIONUMDISKS}}
chown minio-user:minio-user /mnt/disk{1...${MINIONUMDISKS}}

$STD systemctl enable minio
$STD systemctl start minio

msg_ok "Installed MinIO"

motd_ssh
customize

msg_info "Cleaning up"
$STD apt-get autoremove
$STD apt-get autoclean
msg_ok "Cleaned"
