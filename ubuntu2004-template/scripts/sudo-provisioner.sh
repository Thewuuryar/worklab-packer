#!/usr/bin/env bash
set -x

echo "Allowing provisioner user to sudo without password"
echo 'provisioner ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers.d/provisioner