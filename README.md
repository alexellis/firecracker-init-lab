## firecracker-init-lab

Build a Firecracker microVM from a container image, starting a custom Go init process.

## Pre-reqs

* A bare-metal Linux host
* Or a VM that supports nested virtualisation such as on [DigitalOcean](https://m.do.co/c/8d4e75e9886f) or GCP. 

Browse:

* [Go init process](/init/main.go)
* [Makefile](/Makefile)
* [boot.sh](/boot.sh) - commands to start MicroVM
* [Dockerfile](/Dockerfile) - for building the root filesystem

## Usage

Download and install [Firecracker](https://github.com/firecracker-microvm/firecracker/releases/tag/v1.0.0) to `/usr/local/bin/`

Create ftap0 and masquerading with iptables:

```bash
./setup-networking.sh
```

Make the init process binary, and package it into a container, extract the container into a rootfs image:

```bash
make all
```

In one terminal, start firecracker:

```bash
make start
```

In another, instruct it to boot the rootsfs and Kernel:

```bash
make boot
```

Play around in the first terminal and explore the system:

```bash
free -m
cat /proc/cpuinfo
ip addr
ip route

echo "nameserver 1.1.1.1" > /etc/resolv.conf
ping google.com
```

## Running on a Raspberry Pi

Edit Makefile, and change `arch` to `aarch64`

```Makefile
export arch="x86_64"
```

