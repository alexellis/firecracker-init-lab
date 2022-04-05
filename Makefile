.PHONY: init-local root all start boot extract image

all: root extract image

export arch="x86_64"

init-local:
	cd init && \
	go build --tags netgo --ldflags '-s -w -extldflags "-lm -lstdc++ -static"' -o init main.go

root:
	docker build -t alexellis2/custom-init .

kernel:
	curl -o vmlinux -S -L "https://s3.amazonaws.com/spec.ccfc.min/img/quickstart_guide/$(arch)/kernels/vmlinux.bin"
	file ./vmlinux

extract:
	docker rm -f extract || :
	rm -rf rootfs.tar || :
	docker create --name extract alexellis2/custom-init
	docker export extract -o rootfs.tar
	docker rm -f extract

image:
	set -e 
	rm -rf rootfs.img || : ;\
	sudo fallocate -l 5G ./rootfs.img  ;\
	sudo mkfs.ext4 ./rootfs.img  ;\
	TMP=$$(mktemp -d)  ;\
	echo $$TMP  ;\
	sudo mount -o loop ./rootfs.img $$TMP  ;\
	sudo tar -xvf rootfs.tar -C $$TMP  ;\
	sudo umount $$TMP

start:
	sudo rm -f /tmp/firecracker.socket || :
	sudo firecracker --api-sock /tmp/firecracker.socket

boot:
	 sudo ./boot.sh
