= Make Alpine Linux Cloud Hypervisor VM Image

This project provides a script for making customized Alpine Linux disk images for cloud hypervisor firmware style boot.

Base version from https://github.com/alpinelinux/alpine-make-vm-image

## Requirements
* Linux system with common userland (Busybox or GNU coreutils)
* POSIX-sh compatible shell (e.g. Busybox ash, dash, Bash, ZSH)
* qemu-img and qemu-nbd
* gdisk mdev or udevadm
* rsync
* e2fsprogs, btrfs-progs, or xfsprogs

If you have docker, forget I said above, except for qemu-nbd.

## Usage Example
Check NBD module installed
```
$ modprobe nbd
```
Output alpine-v3.18-$(date +%Y-%m-%d).qcow2 will found in ./example
```
$ docker run -it --rm -v ./example:/alpine-make-vm-image -v ./alpine-make-vm-image:/alpine-make-vm-image/alpine-make-vm-image --privileged -v /var/lock:/var/lock -v /dev:/dev -v .example/rootfs:/rootfs tces1/alpine-make-vm-image:latest bash -c './alpine-make-vm-image --image-format qcow2 --repositories-file ./example/repositories --kernel-flavor lts --image-size 5G --packages "$(cat ./example/packages)" --fs-skel-dir /rootfs --fs-skel-chown root:root --script-chroot alpine-v3.18-$(date +%Y-%m-%d).qcow2 -- .example/configure.sh'
```

Enjoy with Cloud Hypervisor!
```
$ qemu-img convert -p -f qcow2 -O raw ./example/alpine-v3.18-$(date +%Y-%m-%d).qcow2 ./example/alpine-v3.18-$(date +%Y-%m-%d).raw

$ cloud-hypervisor --kernel ./hypervisor-fw  --disk path=alpine-v3.18-$(date +%Y-%m-%d).raw --cpus boot=8 --memory size=8192M --serial tty --console off --cmdline "console=ttyS0 root=/dev/vda1" --net "tap=tap_hostfw,mac=,ip=,mask="


```

== License

This project is licensed under http://opensource.org/licenses/MIT/[MIT License].
For the full text of the license, see the link:LICENSE[LICENSE] file.
