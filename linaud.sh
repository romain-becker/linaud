RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
PURPLE='\033[1;35m'
CYAN='\033[1;36m'
WHITE='\033[1;37m'
GREY='\033[1;38m'
RESET='\033[0m'

NOPAUSE='no'

pause () {
if [ $NOPAUSE = "no" ]
    then
	    echo ""
	    echo "${WHITE}Press ENTER to continue Ctrl/C to quit${RESET}"
	    read void
fi
}


# echo " 
# ${BLUE}
# ██      ██ ███    ██  █████  ██    ██ ██████  
# ██      ██ ████   ██ ██   ██ ██    ██ ██   ██ 
# ██      ██ ██ ██  ██ ███████ ██    ██ ██   ██ 
# ██      ██ ██  ██ ██ ██   ██ ██    ██ ██   ██ 
# ███████ ██ ██   ████ ██   ██  ██████  ██████  
# ${RESET}
# "

#SYSTEM INFORMATION
echo "${GREEN}------------------------------[${RESET}${BLUE} SYSTEM INFORMATION ${RESET}${GREEN}]------------------------------${RESET}\n"

echo -n "${WHITE}OS : ${RESET}" && cat /etc/os-release | grep PRETTY | cut -d= -f2-

echo -n "${WHITE}Host : ${RESET}" && cat /proc/sys/kernel/hostname

echo -n "${WHITE}Kernel : ${RESET}" && uname -r 

echo -n "${WHITE}Uptime : ${RESET}" && uptime | cut -c 15-18

echo -n "${WHITE}Packages : ${RESET}" && dpkg --list | wc --lines

echo -n "${WHITE}Shell : ${RESET}" && $SHELL --version

echo -n "${WHITE}Resolution : ${RESET}" && xdpyinfo | awk '/dimensions/ {print $2}'

echo -n "${WHITE}Last update : ${RESET}" && cat /var/log/apt/history.log | grep 'End-Date' | tail -1

pause 

#CPU 
echo "${GREEN}------------------------------[${RESET}${BLUE} CPU ${RESET}${GREEN}]------------------------------${RESET}"

echo -n "${CYAN}\n[CPU flags]${RESET}"

echo -n "${CYAN}\n[pae] --> ${RESET}"
pae=$(grep ^flags /proc/cpuinfo | head -n1 | egrep --color=auto 'pae')
if [ -n "$pae" ]; then echo -n "${GREEN}YES${RESET}"; else echo -n "${RED}NO${RESET}"; fi

echo -n "${CYAN}\n[nx]  --> ${RESET}"
nx=$(grep ^flags /proc/cpuinfo | head -n1 | egrep --color=auto 'nx')
if [ -n "$nx" ]; then echo "${GREEN}YES${RESET}"; else echo "${RED}NO${RESET}"; fi

pause 

#GRUB
echo "${GREEN}------------------------------[${RESET}${BLUE} GRUB ${RESET}${GREEN}]------------------------------${RESET}"

echo "${CYAN}\n[/etc/grub.d/]${RESET}" && ls -lrtha --color=auto /etc/grub.d/

echo "${CYAN}\n[/boot/grub]${RESET}" && ls -lrtha --color=auto /boot/grub

echo -n "${CYAN}\n[GRUB password] --> ${RESET}"
grub_passwd=$(cat /boot/grub/grub.cfg | grep password)
if [ -n "$grub_passwd" ]; then echo "${GREEN}[YES]${RESET}"; else echo "${RED}[NO]${RESET}"; fi

echo -n "${CYAN}\n[IOMMU] --> ${RESET}"
b=$(cat /etc/default/grub | grep iommu=force)
if [ -n "$b" ]; then echo "${GREEN}[YES]${RESET}"; else echo "${RED}[NO]${RESET}"; fi

pause 

#KERNEL
echo "${GREEN}------------------------------[${RESET}${BLUE} KERNEL ${RESET}${GREEN}]------------------------------${RESET}"


echo -n "${CYAN}\n[Dynamic loading of kernel modules is disable] --> ${RESET}"
dynamic_loading_kernel_module=$(sysctl kernel.modules_disabled | grep 1)
if [ -n "$dynamic_loading_kernel_module" ]; then echo "${GREEN}[YES]${RESET}"; else echo "${RED}[NO]${RESET}"; fi

echo -n "${CYAN}\n[Yama security module is enable] --> ${RESET}"
yame=$(sysctl kernel.yama.ptrace_scope | grep 1)
if [ -n "$yama" ]; then echo "${GREEN}[YES]${RESET}"; else echo "${RED}[NO]${RESET}"; fi 

echo -n "${CYAN}\n[Magic SysRq key] --> ${RESET}" && cat /proc/sys/kernel/sysrq

echo "${CYAN}\n[Sysctl]${RESET}"

sysctl -a | grep kernel.sysrq
sysctl -a | grep fs.suid_dumpable
sysctl -a | grep fs.protected_symlinks
sysctl -a | grep fs.protected_hardlinks
sysctl -a | grep kernel.randomize_va_space
sysctl -a | grep vm.mmap_min_addr
sysctl -a | grep kernel.pid_max
sysctl -a | grep kernel.kptr_restrict
sysctl -a | grep kernel.dmesg_restrict
sysctl -a | grep kernel.perf_event_paranoid
sysctl -a | grep kernel.perf_event_max_sample_rate
sysctl -a | grep kernel.perf_cpu_time_max_percent


pause 

#PARTITIONING
echo "${GREEN}------------------------------[${RESET}${BLUE} PARTITIONING ${RESET}${GREEN}]------------------------------${RESET}"

echo "${CYAN}\n[Partitioning]${RESET}" && lsblk 

echo "${CYAN}\n[/etc/fstab]${RESET}" && egrep -v '^\s*#' /etc/fstab

echo "${CYAN}\n[SWAP]${RESET}" && swapon -s 

echo "${CYAN}\n[Partition encryption]${RESET}" && blkid /dev/nvme0n1 | grep --color=auto PTTYPE

pause

#PACKAGES
echo "${GREEN}------------------------------[${RESET}${BLUE} PACKAGES ${RESET}${GREEN}]------------------------------${RESET}"

echo -n "${CYAN}\n[fail2ban] --> ${RESET}"
fail2ban=$(dpkg -l | grep fail2ban)
if [ -n "$fail2ban" ]; then /etc/init.d/fail2ban status | grep Active; else echo "Package is not install"; fi

echo -n "${CYAN}\n[clamav] --> ${RESET}"
clamav=$(dpkg -l | grep clamav)
if [ -n "$clamav" ]; then echo "Package is install"; else echo "Package is not install"; fi

echo -n "${CYAN}\n[clamtk] --> ${RESET}"
clamtk=$(dpkg -l | grep clamtk)
if [ -n "$clamtk" ]; then echo "Package is install"; else echo "Package is not install"; fi

echo -n "${CYAN}\n[lynis] --> ${RESET}"
lynis=$(dpkg -l | grep lynis)
if [ -n "$lynis" ]; then echo "Package is install"; else echo "Package is not install"; fi

echo -n "${CYAN}\n[chkrootkit] --> ${RESET}"
chkrootkit=$(dpkg -l | grep chkrootkit)
if [ -n "$chkrootkit" ]; then echo "Package is install"; else echo "Package is not install"; fi

echo -n "${CYAN}\n[rkhunter] --> ${RESET}"
rkhunter=$(dpkg -l | grep rkhunter)
if [ -n "$rkhunter" ]; then echo "Package is install"; else echo "Package is not install"; fi

echo -n "${CYAN}\n[tiger] --> ${RESET}"
tiger=$(dpkg -l | grep tiger)
if [ -n "$tiger" ]; then echo "Package is install"; else echo "Package is not install"; fi

echo -n "${CYAN}\n[yasat] --> ${RESET}"
yasat=$(dpkg -l | grep yasat)
if [ -n "$yasat" ]; then echo "Package is install"; else echo "Package is not install"; fi


echo -n "${CYAN}\n[iptables] --> ${RESET}"
iptables=$(dpkg -l | grep iptables)
if [ -n "$iptables" ]; then echo "Package is install"; else echo "Package is not install"; fi

echo -n "${CYAN}\n[ufw] --> ${RESET}"
ufw=$(dpkg -l | grep ufw)
if [ -n "$ufw" ]; then echo "Package is install"; else echo "Package is not install"; fi

echo -n "${CYAN}\n[nftables] --> ${RESET}"
nftables=$(dpkg -l | grep nftables)
if [ -n "$nftables" ]; then echo "Package is install"; else echo "Package is not install"; fi

echo -n "${CYAN}\n[firewalld] --> ${RESET}"
firewalld=$(dpkg -l | grep firewalld)
if [ -n "$firewalld" ]; then echo "Package is install"; else echo "Package is not install"; fi

echo -n "${CYAN}\n[bpfilter] --> ${RESET}"
bpfilter=$(dpkg -l | grep bpfilter)
if [ -n "$bpfilter" ]; then echo "Package is install"; else echo "Package is not install"; fi


pause 

#NETWORK
echo "${GREEN}------------------------------[${RESET}${BLUE} NETWORK ${RESET}${GREEN}]------------------------------${RESET}"

echo "${CYAN}\n[Ipv4]${RESET}"
sysctl -a | grep -w net.ipv4.ip_forward 
sysctl -a | grep net.ipv4.conf.all.rp_filter
sysctl -a | grep net.ipv4.conf.default.rp_filter
sysctl -a | grep net.ipv4.conf.all.send_redirects
sysctl -a | grep net.ipv4.conf.default.send_redirects
sysctl -a | grep net.ipv4.conf.all.accept_source_route
sysctl -a | grep net.ipv4.conf.default.accept_source_route
sysctl -a | grep net.ipv4.conf.all.accept_redirects
sysctl -a | grep net.ipv4.conf.all.secure_redirects
sysctl -a | grep net.ipv4.conf.default.accept_redirects
sysctl -a | grep net.ipv4.conf.default.secure_redirects
sysctl -a | grep net.ipv4.conf.all.log_martians
sysctl -a | grep net.ipv4.tcp_rfc1337
sysctl -a | grep net.ipv4.icmp_ignore_bogus_error_responses
sysctl -a | grep net.ipv4.ip_local_port_range
sysctl -a | grep net.ipv4.tcp_syncookies

echo "${CYAN}\n[Ipv6]${RESET}"
sysctl -a | grep net.ipv6.conf.all.disable_ipv6
sysctl -a | grep net.ipv6.conf.all.router_solicitations
sysctl -a | grep net.ipv6.conf.default.router_solicitations
sysctl -a | grep net.ipv6.conf.all.accept_ra_rtr_pref
sysctl -a | grep net.ipv6.conf.default.accept_ra_rtr_pref
sysctl -a | grep net.ipv6.conf.all.accept_ra_pinfo
sysctl -a | grep net.ipv6.conf.default.accept_ra_pinfo
sysctl -a | grep net.ipv6.conf.all.accept_ra_defrtr
sysctl -a | grep net.ipv6.conf.default.accept_ra_defrtr
sysctl -a | grep net.ipv6.conf.all.autoconf
sysctl -a | grep net.ipv6.conf.default.autoconf
sysctl -a | grep net.ipv6.conf.all.accept_redirects
sysctl -a | grep net.ipv6.conf.default.accept_redirects
sysctl -a | grep net.ipv6.conf.all.accept_source_route
sysctl -a | grep net.ipv6.conf.default.accept_source_route
sysctl -a | grep net.ipv6.conf.all.max_addresses
sysctl -a | grep net.ipv6.conf.default.max_addresses

echo "${CYAN}\n[OpenPorts]${RESET}"
netstat -antp

pause 

echo "${GREEN}------------------------------[${RESET}${BLUE} SSH ${RESET}${GREEN}]------------------------------${RESET}"

cat /etc/ssh/sshd_config | grep PermitRootLogin
cat /etc/ssh/sshd_config | grep PermitEmptyPasswords
cat /etc/ssh/sshd_config | grep DefaultPort
cat /etc/ssh/sshd_config | grep Protocol
cat /etc/ssh/sshd_config | grep ClientAliveInterval
cat /etc/ssh/sshd_config | grep ClientAliveCountMax
cat /etc/ssh/sshd_config | grep AllowUsers
cat /etc/ssh/sshd_config | grep AllowGroups
cat /etc/ssh/sshd_config | grep X11Forwarding

pause 

echo "${GREEN}------------------------------[${RESET}${BLUE} OTHERS ${RESET}${GREEN}]------------------------------${RESET}"

echo -n "${CYAN}\n[SELinux] --> ${RESET}" && sestatus 

echo -n "${CYAN}\n[AppArmor] --> ${RESET}" && aa-status

echo -n "${CYAN}\n[Access to virtual consoles] --> ${RESET}"
virtual_consoles=$(grep "^[^#;]" /etc/pam.d/login | grep pam_securetty.so)
if [ -n "$virtual_consoles" ]; then echo "${GREEN}[YES]${RESET}"; else echo "${GREEN}[NO]${RESET}"; fi

#Use a distribution with an init system other than systemd. systemd contains a lot of unnecessary attack surface and inserts a considerable amount of complexity into the most privileged user space component
echo -n "${CYAN}\n[Init system] --> ${RESET}" && stat /sbin/init | grep File: | sed 's/ //g' | cut -d: -f2-

# echo "${CYAN}\n[Multi-user.target services]${RESET}"
# ls -lrtha /etc/systemd/system/multi-user.target.wants/

echo "${CYAN}\n[/boot]${RESET}"

echo "${PURPLE}[ls -lrtha /boot/]${RESET}" && ls --color=auto -lrtha /boot/

echo "${PURPLE}[ls -lrth / | grep boot]${RESET}" && ls -lrth / | grep --color=auto boot

echo "${CYAN}\n[Accounts With Empty Passwords]${RESET}"
empty_passwd=$(awk -F: '($2 == "") {print}' /etc/shadow)
if [ -n "$empty_passwd" ]; then echo "$empty_passwd"; else echo "${GREEN}[NO]${RESET}"; fi

echo "${CYAN}\n[Nologin accounts]${RESET}" && cat /etc/passwd | grep -v nologin

echo "${CYAN}\n[$USER chage details]${RESET}" && chage -l $USER

echo "${CYAN}\n[/etc/login.defs ]${RESET}" && egrep -v '^\s*#' /etc/login.defs | grep PASS

echo "${CYAN}\n[Accounts UID Set To 0]${RESET}"
uid=$(awk -F: '($3 == "0") {print}' /etc/passwd)
if [ -n "$uid" ]; then echo "$uid"; else echo "[0]"; fi

echo "${CYAN}\n[Sudo privileges]${RESET}" && ls -lrtha /usr/bin/sudo

echo "${CYAN}\n[Umask]${RESET}" && umask

echo "${CYAN}\n[etc/pam.d/common-password]${RESET}" && grep -v '^\s*#' /etc/pam.d/common-password

#echo "${CYAN}\n[etc/security/limits.conf]${RESET}" && grep -v '^\s*#' /etc/security/limits.conf


echo "${CYAN}\n[Sensitives files]${RESET}"
ls -l /etc/sudoers | grep --color=auto sudoers
ls -l /etc/shadow | grep --color=auto shadow
ls -l /etc/gshadow | grep --color=auto gshadow 
ls -l /etc/passwd | grep --color=auto passwd 
ls -l /etc/group | grep --color=auto group
ls -l /proc/cmdline | grep --color=auto cmdline
#ls -l /etc/rc.*
ls -l /etc/profile | grep --color=auto profile
ls -l /etc/hosts | grep --color=auto hosts
ls -l /etc/resolv.conf | grep --color=auto resolv.conf

echo "${CYAN}\n[CRON]${RESET}" && grep -v '^\s*#' /etc/crontab
