#!/usr/bin/env bash
set -x

echo "Modifying /etc/ssh/sshd_config..."
sed -i".bak" "s/\#*\(PermitRootLogin\s*\).*$/\1no/" /etc/ssh/sshd_config
sudo systemctl restart sshd