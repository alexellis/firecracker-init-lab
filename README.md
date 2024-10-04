## firecracker-init-lab

Build a microVM from a container image

> Many of the examples you'll find are broken due to changes in Firecracker 1.0 - the official quickstart guide doesn't cover the most interesting thing - working Internet access - or extracting a filesystem from a container. This lab extends [the official quickstart](https://github.com/firecracker-microvm/firecracker/blob/main/docs/getting-started.md) so that you can explore what an init process does, and add networking.

## Pre-reqs

* A bare-metal Linux host - [where can you get bare metal?](https://github.com/alexellis/awesome-baremetal#bare-metal-cloud)
* Or a VM that supports nested virtualisation such as on [DigitalOcean](https://m.do.co/c/8d4e75e9886f) or GCP. 
* Docker installed

Browse:

* [Go init process](/init/main.go)
* [Makefile](/Makefile)
* [boot.sh](/boot.sh) - commands to start MicroVM
* [setup-networking.sh](./setup-networking.sh) - configure a tap adapter, IP forwarding and IP masquerading
* [Dockerfile](/Dockerfile) - for building the root filesystem

## Usage

Download and install [Firecracker](https://github.com/firecracker-microvm/firecracker/releases) to `/usr/local/bin/`

Or, alternatively, [Arkade](https://arkade.dev) can do this for you with:

```
curl -SLs https://get.arkade.dev | sudo sh
sudo arkade system install firecracker
```

Edit the `IFNAME` in `setup-networking.sh` to match your host's network interface.

Then run the script to create the ftap0 device, and to setup IP masquerading with iptables:

```bash
./setup-networking.sh
```

Download the quickstart Kernel:

```
make kernel
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
ping -c 4 google.com

apk add --no-cache curl

curl -i https://inlets.dev
```

## Expose a TCP or HTTP service to the Internet

Once you've got something interesting running like a HTTP server, or an SSHD daemon, you can then get ingress from the public Internet using an [inlets tunnel](https://inlets.dev). Inlets is a static binary, and there are a couple of simple tutorials you can follow depending on what you want to expose.

* [HTTPS tunnel with Let's Encrypt](https://docs.inlets.dev/tutorial/automated-http-server/)
* [TCP tunnel for SSH, reverse proxy etc](https://docs.inlets.dev/tutorial/ssh-tcp-tunnel/)

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

## Faster, more secure CI with Firecracker and actuated

We demoed actuated for fast and secure CI with Firecracker, since then it's being used in production and has launched over 100k VMs so far.

Read more on the website, on the blog or in the docs at: [actuated.dev](https://actuated.dev).

Watch a demo:

* [Actuated for GitHub Actions](https://youtu.be/2o28iUC-J1w?si=FfDcnwemqWPWaDvF)
* [Acuated for GitLab CI](https://www.youtube.com/watch?v=PybSPduDT6s)
