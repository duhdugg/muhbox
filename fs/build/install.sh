#!/usr/bin/env bash

set -euxo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

function _install_packages {
  cd $SCRIPT_DIR
  extra_packages=$(cat extra-packages | sed 's/#.*//')
  python_build_deps=$(cat python-build-dependencies | sed 's/#.*//')
  apk update
  apk upgrade
  apk add $extra_packages
  apk add $python_build_deps
}

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
  ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/docker
  ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/dogsay
  ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/flatpak
  ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/podman
  ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/rpm-ostree
  ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/transactional-update
}

_log_build_date {
 date -I seconds > /build/build_date.txt
}

function _main {
  _install_packages
  _install_pyenv
  _install_ngrok
  _import_host_commands
  _fix_permissions
  _log_build_date
}

_main
