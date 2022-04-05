## firecracker-init-lab

Build a Firecracker microVM from a container image, starting a custom Go init process.

Browse:

* [Go init process](/init/main.go)
* [Makefile](/Makefile)
* [boot.sh](/boot.sh) - commands to start MicroVM
* [Dockerfile](/Dockerfile) - for building the root filesystem

## Usage

Create ftap0:

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
free -h
lscpu
ip addr
ip route

echo "nameserver 1.1.1.1" > /etc/resolv.conf
ping google.com
```

