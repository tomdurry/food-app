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
    sudo apt-get install -y unzip
    curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip"
    unzip -o awscliv2.zip
    chmod +x ./aws/install
    sudo ./aws/install
    sudo chmod +x /usr/local/bin/aws
    rm -f awscliv2.zip
    rm -rf ./aws
} &

# kubectl
{
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl"
    chmod +x kubectl
    sudo mv kubectl /usr/local/bin/
    rm kubectl

} &

# eksctl
{
    ARCH=arm64
    PLATFORM=$(uname -s)_$ARCH
    curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"
    curl -sL "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_checksums.txt" | grep $PLATFORM | sha256sum --check
    tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp && rm eksctl_$PLATFORM.tar.gz
    sudo mv /tmp/eksctl /usr/local/bin
} &

# docker-compose
{
    sudo apt-get update
    sudo apt-get install -y docker-compose
} &

# kubectx と kubens
{
    sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
    sudo ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
    sudo ln -s /opt/kubectx/kubens /usr/local/bin/kubens

} &

# kube-ps1
{
    sudo git clone https://github.com/jonmosco/kube-ps1 /opt/kube-ps1
} &

# stern
{
    go install github.com/stern/stern@latest
} &

# Helm
{
    curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
} &

wait
