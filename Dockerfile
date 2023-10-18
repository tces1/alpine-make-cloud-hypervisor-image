FROM rockylinux:9

RUN dnf install -y wget qemu-img util-linux e4fsprogs xfsprogs rsync gdisk dosfstools grub2-efi-x64-modules
RUN mkdir /alpine-make-vm-image

WORKDIR /alpine-make-vm-image