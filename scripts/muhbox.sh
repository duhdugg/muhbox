#!/usr/bin/env bash

set -euxo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

function _install_pyenv {
  cd /opt
  git clone --depth=1 https://github.com/pyenv/pyenv
  cd pyenv
  src/configure && make -C src
}

function _install_ngrok {
  cd /
  mkdir -p /opt/ngrok/bin
  cd /opt/ngrok
  wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz
  tar xvzf ngrok-v3-stable-linux-amd64.tgz -C /opt/ngrok/bin
}

function _fix_permissions {
  cd /
  chown -R 1000:1000 /opt/pyenv
  chown -R 1000:1000 /opt/ngrok
}

function _import_host_commands {
  ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/borg
  ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/dogsay
}

function _log_build_date {
 date -Iseconds > /build_date.txt
}

# Symlink distrobox shims
./distrobox-shims.sh

# Update the container and install packages
apk update && apk upgrade
grep -v '^#' ./muhbox.packages | xargs apk add
grep -v '^#' ./muhbox-python-build-deps.packages | xargs apk add

_install_pyenv
_install_ngrok
_import_host_commands
_fix_permissions
_log_build_date
