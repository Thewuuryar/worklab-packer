#!/usr/bin/env bash
set -x

VMWARE_ISO=/dev/sr1
VMWARE_MNTDIR=$(mktemp --tmpdir=/tmp -q -d -t vmware_mnt_XXXXXX)
VMWARE_TMPDIR=$(mktemp --tmpdir=/tmp -q -d -t vmware_XXXXXX)

# Extract tools
mount -o loop $VMWARE_ISO $VMWARE_MNTDIR
tar zxf $VMWARE_MNTDIR/VMwareTools*.tar.gz -C $VMWARE_TMPDIR
umount $VMWARE_MNTDIR

# Remove open-vm-tools
sudo apt autoremove -y open-vm-tools --purge

# Install tools
$VMWARE_TMPDIR/vmware-tools-distrib/vmware-install.pl -f -d

# Clean up
rm -f $VMWARE_ISO
rm -rf $VMWARE_MNTDIR
rm -rf $VMWARE_TMPDIR
