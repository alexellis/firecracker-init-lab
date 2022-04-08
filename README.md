## firecracker-init-lab

Build a microVM from a container image

> Many of the examples you'll find are broken due to changes in Firecracker 1.0 - the official quickstart guide doesn't cover the most interesting thing - working Internet access - or extracting a filesystem from a container. This lab extends [the official quickstart](https://github.com/firecracker-microvm/firecracker/blob/main/docs/getting-started.md) so that you can explore what an init process does, and add networking.

## Pre-reqs

* A bare-metal Linux host
* Or a VM that supports nested virtualisation such as on [DigitalOcean](https://m.do.co/c/8d4e75e9886f) or GCP. 
* Docker installed

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

ping -c1 1.1.1.1

echo "nameserver 1.1.1.1" > /etc/resolv.conf
ping -c1 google.com
```

## Running on a Raspberry Pi

Edit Makefile, and change `arch` to `aarch64`

```Makefile
export arch="x86_64"
```

## Live-event - A cracking time with Richard Case of Weaveworks

[Richard Case](https://twitter.com/fruit_case) will join me as we explain to you why we're so excited about Firecracker, what use-cases we see and try to show you a little of what can be done with it. Richard's been at the sharp end of this technology for months, and is working on a cutting edge bare-metal Kubernetes project called Liquid Metal.

[![Live stream](https://img.youtube.com/vi/CYCsa5e2vqg/hqdefault.jpg)](https://www.youtube.com/watch?v=CYCsa5e2vqg)

> You'll hear more about it on Friday lunch at 12:00pm BST.

[Subscribe & remind](https://www.youtube.com/watch?v=CYCsa5e2vqg)

If you can't make it live, then you'll be able to jump onto the replay with your morning coffee.
