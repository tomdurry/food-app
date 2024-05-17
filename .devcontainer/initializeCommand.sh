#!/bin/bash

# If MacOS, execute the ssh-add command on the host machine
if [[ "$OSTYPE" == "darwin"* ]]; then
    ssh-add --apple-use-keychain ~/.ssh/id_rsa
fi

# create .env
cat <<-EOF > .devcontainer/.env
GIT_NAME=$(git config --get user.name)
GIT_EMAIL=$(git config --get user.email)
EOF