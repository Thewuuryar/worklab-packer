#!/usr/bin/env bash
set -x

echo "Deleting provisioner user"
userdel -rf provisioner
rm /etc/sudoers.d/provisioner