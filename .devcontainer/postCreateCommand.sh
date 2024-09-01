#!/bin/bash
set -ex

# gitコマンドを利用するために必要な設定
git config --global --add safe.directory "${PWD}"
git config --global user.name "${GIT_NAME}"
git config --global user.email "${GIT_EMAIL}"
git config --global push.autoSetupRemote true &

# Delve
go install github.com/go-delve/delve/cmd/dlv@latest &

# Terraform
{
    sudo apt-get update
    sudo apt-get install -y gnupg software-properties-common
    wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt-get update
    sudo apt-get install -y terraform
} &

# AWS CLI
{
    curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip"
    unzip -o awscliv2.zip
    chmod +x ./aws/install
    chmod -R 755 ./aws
    sudo ./aws/install
    rm -f awscliv2.zip
    rm -rf ./aws
} &

wait
