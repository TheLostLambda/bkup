#!/bin/sh
MOUNT=/run/media/tll/BKUP
OPTIONS=remount,compress-force,autodefrag,compress=zstd
DEVICE=$(mount -v | grep $MOUNT | awk '{print $1}')
sudo mount -o $OPTIONS $DEVICE $MOUNT
sudo snapper -c bkup create -c timeline
sudo rsync -azAXSvvv --compress-level=9 --delete --stats --human-readable --progress --exclude-from=- -e "ssh -i /home/alarm/.ssh/id_rsa" root@10.0.0.1:/ $MOUNT <<EOF
/mnt
/dev
/sys
/proc
/.snapshots
/var/lib/monero
EOF

