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


echo " 
${BLUE}
██      ██ ███    ██  █████  ██    ██ ██████  
██      ██ ████   ██ ██   ██ ██    ██ ██   ██ 
██      ██ ██ ██  ██ ███████ ██    ██ ██   ██ 
██      ██ ██  ██ ██ ██   ██ ██    ██ ██   ██ 
███████ ██ ██   ████ ██   ██  ██████  ██████  
${RESET}
"

echo "${GREEN}------------------------------[${RESET}${BLUE} SYSTEM INFORMATION ${RESET}${GREEN}]------------------------------${RESET}"

echo -n "${WHITE}OS : ${RESET}" && cat /etc/os-release | grep PRETTY | cut -d= -f2-

echo -n "${WHITE}Host : ${RESET}" && cat /proc/sys/kernel/hostname

echo -n "${WHITE}Kernel : ${RESET}" && uname -r 

echo -n "${WHITE}Uptime : ${RESET}" && uptime | cut -c 15-18

echo -n "${WHITE}Packages : ${RESET}" && dpkg --list | wc --lines

echo -n "${WHITE}Shell : ${RESET}" && $SHELL --version

echo -n "${WHITE}Resolution : ${RESET}" && xdpyinfo | awk '/dimensions/ {print $2}'

echo -n "${WHITE}Last update : ${RESET}" && cat /var/log/apt/history.log | grep 'End-Date' | tail -1

pause 


echo "${GREEN}------------------------------[${RESET}${BLUE} GRUB ${RESET}${GREEN}]------------------------------${RESET}"

echo "${CYAN}\n[/etc/grub.d/]${RESET}"
ls -lrtha --color=auto /etc/grub.d/

echo "${CYAN}\n[/boot/grub]${RESET}"
ls -lrtha --color=auto /boot/grub

echo -n "${CYAN}\n[GRUB password] --> ${RESET}"
a=$(cat /boot/grub/grub.cfg | grep password)
if [ -n "$a" ]; then
    echo "${GREEN}[YES]${RESET}"
else
    echo "${RED}[NO]${RESET}"
fi


pause 




echo -n "${CYAN}\n[IOMMU] --> ${RESET}"
b=$(cat /etc/default/grub | grep iommu=force)
if [ -n "$b" ]; then
    echo "${GREEN}[YES]${RESET}"
else
    echo "${RED}[NO]${RESET}"
fi

echo -n "${CYAN}\n[Dynamic loading of kernel modules is disable] --> ${RESET}"
c=$(sysctl kernel.modules_disabled | grep 1)
if [ -n "$c" ]; then
    echo "${GREEN}[YES]${RESET}"
else
    echo "${RED}[NO]${RESET}"
fi

echo -n "${CYAN}\n[Yama security module is enable] --> ${RESET}"
d=$(sysctl kernel.yama.ptrace_scope | grep 1)
if [ -n "$d" ]; then
    echo "${GREEN}[YES]${RESET}"
else
    echo "${RED}[NO]${RESET}"
fi 

echo -n "${CYAN}\n[Access to virtual consoles] --> ${RESET}"
e=$(grep "^[^#;]" /etc/pam.d/login | grep pam_securetty.so)
if [ -n "$e" ]; then
    echo "${GREEN}[YES]${RESET}"
else
    echo "${GREEN}[NO]${RESET}"
fi

echo -n "${CYAN}\n[Magic SysRq key] --> ${RESET}"
cat /proc/sys/kernel/sysrq


echo "${CYAN}\n[/etc/fstab]${RESET}"
egrep -v '^\s*#' /etc/fstab

#Use a distribution with an init system other than systemd. systemd contains a lot of unnecessary attack surface and inserts a considerable amount of complexity into the most privileged user space component
echo -n "${CYAN}\n[Init system] --> ${RESET}"
stat /sbin/init | grep File: | sed 's/ //g' | cut -d: -f2-

# echo "${CYAN}\n[Multi-user.target services]${RESET}"
# ls -lrtha /etc/systemd/system/multi-user.target.wants/




echo "${BLUE}\n[+] SYSTEM ${RESET}"
echo -n "---------------------------------------------"

echo -n "${CYAN}\n[CPU flags]${RESET}"
echo -n "${CYAN}\n[pae] --> ${RESET}"
f=$(grep ^flags /proc/cpuinfo | head -n1 | egrep --color=auto 'pae')
if [ -n "$f" ]; then
    echo -n "${GREEN}YES${RESET}"
else
    echo -n "${RED}NO${RESET}"
fi

echo -n "${CYAN}\n[nx]  --> ${RESET}"
g=$(grep ^flags /proc/cpuinfo | head -n1 | egrep --color=auto 'nx')
if [ -n "$g" ]; then
    echo "${GREEN}YES${RESET}"
else
    echo "${RED}NO${RESET}"
fi


echo "${CYAN}\n[SWAP]${RESET}"
swapon -s 

echo "${CYAN}\n[Partitioning]${RESET}"
lsblk 

echo "${CYAN}\n[Partition encryption]${RESET}"
blkid /dev/nvme0n1 | grep --color=auto PTTYPE

echo "${CYAN}\n[/boot]${RESET}"

echo "${PURPLE}[ls -lrtha /boot/]${RESET}"
ls --color=auto -lrtha /boot/

echo "${PURPLE}[ls -lrth / | grep boot]${RESET}"
ls -lrth / | grep --color=auto boot

echo "${CYAN}\n[Accounts With Empty Passwords]${RESET}"
h=$(awk -F: '($2 == "") {print}' /etc/shadow)
if [ -n "$h" ]; then
    echo "$h"
else
    echo "${GREEN}[NO]${RESET}"
fi

echo "${CYAN}\n[Nologin accounts]${RESET}"
cat /etc/passwd | grep -v nologin

echo "${CYAN}\n[$USER chage details]${RESET}"
chage -l $USER

echo "${CYAN}\n[/etc/login.defs ]${RESET}"
egrep -v '^\s*#' /etc/login.defs | grep PASS


echo "${CYAN}\n[Accounts UID Set To 0]${RESET}"
i=$(awk -F: '($3 == "0") {print}' /etc/passwd)
if [ -n "$i" ]; then
    echo "$i"
else
    echo "[0]"
fi


echo "${CYAN}\n[Sudo privileges]${RESET}"
ls -lrtha /usr/bin/sudo

echo "${CYAN}\n[Umask]${RESET}"
umask

echo "${CYAN}\n[fail2ban]${RESET}"
j=$(dpkg -l | grep fail2ban)
if [ -n "$j" ]; then
    /etc/init.d/fail2ban status | grep Active
else
    echo "Package is not install"
fi


echo "${CYAN}\n[clamav]${RESET}"
jj=$(dpkg -l | grep clamav)
if [ -n "$jj" ]; then
    echo "Package is install"
else
    echo "Package is not install"
fi

echo "${CYAN}\n[clamtk]${RESET}"
jjj=$(dpkg -l | grep clamtk)
if [ -n "$jjj" ]; then
    echo "Package is install"
else
    echo "Package is not install"
fi

echo "${CYAN}\n[lynis]${RESET}"
jjjj=$(dpkg -l | grep lynis)
if [ -n "$jjjj" ]; then
    echo "Package is install"
else
    echo "Package is not install"
fi

echo "${CYAN}\n[chkrootkit]${RESET}"
jjjjj=$(dpkg -l | grep chkrootkit)
if [ -n "$jjjjj" ]; then
    echo "Package is install"
else
    echo "Package is not install"
fi

echo "${CYAN}\n[rkhunter]${RESET}"
jjjjjj=$(dpkg -l | grep rkhunter)
if [ -n "$jjjjjj" ]; then
    echo "Package is install"
else
    echo "Package is not install"
fi

echo "${CYAN}\n[tiger]${RESET}"
jjjjjjj=$(dpkg -l | grep tiger)
if [ -n "$jjjjjjj" ]; then
    echo "Package is install"
else
    echo "Package is not install"
fi

echo "${CYAN}\n[yasat]${RESET}"
jjjjjjjj=$(dpkg -l | grep yasat)
if [ -n "$jjjjjjjj" ]; then
    echo "Package is install"
else
    echo "Package is not install"
fi





echo "${BLUE}\n[+] Network sysctl ${RESET}"
echo -n "---------------------------------------------"

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


echo "${BLUE}\n[+] System sysctl ${RESET}"
echo "---------------------------------------------"

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


