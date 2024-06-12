#!/bin/bash
set -ex
# gitコマンドを利用するために必要な設定
git config --global --add safe.directory "${PWD}"

git config --global user.name "${GIT_NAME}"
git config --global user.email "${GIT_EMAIL}"
git config --global push.autoSetupRemote true