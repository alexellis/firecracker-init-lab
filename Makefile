.PHONY: init-local root all start boot extract image

all: root extract image

export arch="x86_64"

# init-local builds a static binary for local testing, but the lab uses a multi-stage
# Dockerfile for this instead - https://docs.docker.com/develop/develop-images/multistage-build/
init-local:
	cd init && \
	go build --tags netgo --ldflags '-s -w -extldflags "-lm -lstdc++ -static"' -o init main.go

root:
	docker build -t alexellis2/custom-init .

pause:
	sudo curl --unix-socket /tmp/firecracker.socket -i \
		-X PATCH 'http://localhost/vm' \
		-H 'Accept: application/json'           \
		-H 'Content-Type: application/json'     \
		-d '{"state": "Paused"}'

snapshot:
	sudo curl --unix-socket /tmp/firecracker.socket -i \
		-X PUT 'http://localhost/snapshot/create' \
		-H  'Accept: application/json' \
		-H  'Content-Type: application/json' \
		-d '{"snapshot_type": "Full", "snapshot_path": "./snapshot_file", "mem_file_path": "./mem_file"}'

resume:
	sudo curl --unix-socket /tmp/firecracker.socket -i \
		-X PATCH 'http://localhost/vm' \
		-H 'Accept: application/json'           \
		-H 'Content-Type: application/json'     \
		-d '{"state": "Resumed"}'

restore:
	sudo curl --unix-socket /tmp/firecracker.socket -i \
		-X PUT 'http://localhost/snapshot/load' \
		-H  'Accept: application/json' \
		-H  'Content-Type: application/json' \
    -d "{ \
            \"snapshot_path\": \"./snapshot_file\", \
            \"mem_backend\": { \
                \"backend_path\": \"./mem_file\", \
                \"backend_type\": \"File\" \
            }, \
            \"enable_diff_snapshots\": true, \
            \"resume_vm\": false \
        }"

# Get the AWS sample image
# change to Image when using aarch64, instead of vmlinux.bin
kernel:
	curl -o vmlinux -S -L "https://s3.amazonaws.com/spec.ccfc.min/firecracker-ci/v1.10/$(arch)/vmlinux-5.10.223"

# Extract a root filesystem into a tar
extract:
	docker rm -f extract || :
	rm -rf rootfs.tar || :
	docker create --name extract alexellis2/custom-init
	docker export extract -o rootfs.tar
	docker rm -f extract

# Allocate a 5GB disk image, then extract the rootfs.tar from the 
# container into it
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

# Start a firecracker process, ready for commands
start:
	sudo rm -f /tmp/firecracker.socket || :
	sudo firecracker --api-sock /tmp/firecracker.socket

# Sends commands to boot the firecracker process started via "make start"
boot:
	 sudo ./boot.sh
