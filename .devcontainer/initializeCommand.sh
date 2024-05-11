#!/bin/bash

# If MacOS, execute the ssh-add command on the host machine
if [[ "$OSTYPE" == "darwin"* ]]; then
    ssh-add --apple-use-keychain ~/.ssh/id_rsa
fi