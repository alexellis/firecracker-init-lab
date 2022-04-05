#!/bin/bash

sudo curl --unix-socket /tmp/firecracker.socket -i \
      -X PUT 'http://localhost/boot-source'   \
      -H 'Accept: application/json'           \
      -H 'Content-Type: application/json'     \
      -d "{ 
            \"kernel_image_path\": \"./vmlinux\", 
            \"boot_args\": \"console=ttyS0 reboot=k panic=1 pci=off init=/init ip=172.16.0.2::172.16.0.1:255.255.255.0::eth0:off\" 
       }"
sudo curl -X PUT \
    --unix-socket /tmp/firecracker.socket \
    'http://localhost/network-interfaces/eth0' \
    -H accept:application/json \
    -H content-type:application/json \
    -d '{
        "iface_id": "eth0",
        "host_dev_name": "ftap00"
    }'

sudo curl --unix-socket /tmp/firecracker.socket -i \
    -X PUT 'http://localhost/drives/rootfs' \
    -H 'Accept: application/json'           \
    -H 'Content-Type: application/json'     \
    -d "{ \
            \"drive_id\": \"rootfs\", 
            \"path_on_host\": \"./rootfs.img\", 
            \"is_root_device\": true, 
            \"is_read_only\": false 
    }"

sudo curl --unix-socket /tmp/firecracker.socket -i \
    -X PUT 'http://localhost/actions'       \
    -H  'Accept: application/json'          \
    -H  'Content-Type: application/json'    \
    -d '{ 
        "action_type": "InstanceStart" 
    }'