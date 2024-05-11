#!/bin/bash
set -ex
# gitコマンドを利用するために必要な設定
git config --global --add safe.directory "${PWD}"