#!/bin/sh

_step_counter=0
step() {
	_step_counter=$(( _step_counter + 1 ))
	printf '\n\033[1;36m%d) %s\033[0m\n' $_step_counter "$@" >&2  # bold cyan
}

step 'Set up timezone'
setup-timezone -z Asia/Shanghai

step 'Set up networking'
cat > /etc/network/interfaces <<-EOF
	iface lo inet loopback
	iface eth0 inet dhcp
EOF
ln -s networking /etc/init.d/net.lo
ln -s networking /etc/init.d/net.eth0

step 'Adjust rc.conf'
sed -Ei \
	-e 's/^[# ](rc_depend_strict)=.*/\1=NO/' \
	-e 's/^[# ](rc_logger)=.*/\1=YES/' \
	-e 's/^[# ](unicode)=.*/\1=YES/' \
	/etc/rc.conf

step 'Customer Settings'
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
echo "ttyS0::respawn:/sbin/getty -L ttyS0 115200 vt100" >> /etc/inittab
echo "cgroup /sys/fs/cgroup cgroup defaults 0 0" >> /etc/fstab

echo "root:areyouok" | sudo chpasswd
mkdir /root/.ssh
cat << EOF >> /etc/local.d/default.start
#!/bin/sh
mkdir -p /var/run/netns
EOF
chmod +x /etc/local.d/default.start
mkdir -p /repo/root

step 'Enable services'
rc-update add acpid default
rc-update add chronyd default
rc-update add crond default
rc-update add net.eth0 default
rc-update add net.lo boot
rc-update add termencoding boot
rc-update add docker boot
rc-update add sshd default
rc-update add local default

step "Finished!"

