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
DISTRIB=$(cat /etc/os-release | grep -m1 ID= | cut -d= -f2-)

if [ ${DISTRIB} = "kali" ]; then
	ECHO='echo'
else
	ECHO='echo -e'
fi

if [ ${DISTRIB} = "arch" ]; then
	CHECK_PACKAGES='pacman -Q'
else
	CHECK_PACKAGES='dpkg -l'	
fi

pause () {
if [ $NOPAUSE = "no" ]
    then
	    ${ECHO} ""
	    ${ECHO} "${WHITE}Press ENTER to continue Ctrl/C to quit${RESET}"
	    read void
fi
}


${ECHO} " 
${BLUE}
 ██      ██ ███    ██  █████  ██    ██ ██████  
 ██      ██ ████   ██ ██   ██ ██    ██ ██   ██ 
 ██      ██ ██ ██  ██ ███████ ██    ██ ██   ██ 
 ██      ██ ██  ██ ██ ██   ██ ██    ██ ██   ██ 
 ███████ ██ ██   ████ ██   ██  ██████  ██████  
${RESET}
"


${ECHO} "\n"
${ECHO} "${GREEN} GREEN ${RESET}  GOOD configuration"
${ECHO} "${YELLOW} YELLOW ${RESET} OPTIONAL configuration"
${ECHO} "${RED} RED ${RESET}    BAD configuration"
${ECHO} "\n"



#SYSTEM INFORMATION
${ECHO} "${PURPLE}------------------------------[${RESET}${BLUE} SYSTEM INFORMATION ${RESET}${PURPLE}]------------------------------${RESET}\n"

${ECHO} -n "${WHITE}OS : ${RESET}" && cat /etc/os-release | grep PRETTY | cut -d= -f2-

${ECHO} -n "${WHITE}Host : ${RESET}" && cat /proc/sys/kernel/hostname

${ECHO} -n "${WHITE}Kernel : ${RESET}" && uname -r 

${ECHO} -n "${WHITE}Installation date : ${RESET}" && stat / | awk '/Birth: /{print $2}'

${ECHO} -n "${WHITE}Uptime : ${RESET}" && uptime | cut -c 15-18 

${ECHO} -n "${WHITE}Packages : ${RESET}" && if [ ${DISTRIB} = "arch" ]; then pacman -Q | wc -l; else dpkg -l | wc -l; fi

${ECHO} -n "${WHITE}Shell : ${RESET}" && $SHELL --version | grep -m1 linux

${ECHO} -n "${WHITE}Resolution : ${RESET}" && xrandr | grep '*' |  awk '{print $1}' 

${ECHO} -n "${WHITE}Last update : ${RESET}" && if [ ${DISTRIB} = "arch" ]; then  awk 'END{sub(/\[/,""); print $1}' /var/log/pacman.log; else ls -l /var/cache/apt/pkgcache.bin | cut -d' ' -f6,7,8,9 ; fi 

${ECHO} -n "${WHITE}IP address : ${RESET}" && hostname -I | awk '{print $1}'

${ECHO} -n "${WHITE}MAC address : ${RESET}" && hostname -I | awk '{print $2}'

${ECHO} -n "${WHITE}Administrators : ${RESET}" && cat /etc/group | grep adm | cut -d: -f4-

# ${ECHO} -n "${WHITE}MAC address : ${RESET}" && arp | awk '{print $3}' | tr -d 'HWaddress' | tr '\n' ' ' 

pause 

#CPU 
${ECHO} "${PURPLE}------------------------------[${RESET}${BLUE} CPU ${RESET}${PURPLE}]---------------------------------------------${RESET}"

${ECHO} -n "${CYAN}\n[CPU flags]${RESET}"

${ECHO} -n "${CYAN}\n[pae] --> ${RESET}"
pae=$(grep ^flags /proc/cpuinfo | head -n1 | egrep --color=auto 'pae')
if [ -n "$pae" ]; then ${ECHO} -n "${GREEN}YES${RESET}"; else ${ECHO} -n "${RED}NO${RESET}"; fi

${ECHO} -n "${CYAN}\n[nx]  --> ${RESET}"
nx=$(grep ^flags /proc/cpuinfo | head -n1 | egrep --color=auto 'nx')
if [ -n "$nx" ]; then ${ECHO} "${GREEN}YES${RESET}"; else ${ECHO} "${RED}NO${RESET}"; fi

pause 

#GRUB
${ECHO} "${PURPLE}------------------------------[${RESET}${BLUE} GRUB ${RESET}${PURPLE}]--------------------------------------------${RESET}"

${ECHO} "${CYAN}\n[/etc/grub.d/]${RESET}" && ls -lrtha --color=auto /etc/grub.d/

${ECHO} "${CYAN}\n[/boot/grub]${RESET}" && ls -lrtha --color=auto /boot/grub

${ECHO} -n "${CYAN}\n[GRUB password] --> ${RESET}"
grub_passwd=$(if [ ${DISTRIB} = "kali" ]; then cat /boot/grub/grub.cfg | grep password; else cat /etc/grub.d/40_custom | grep password ;fi )
if [ -n "$grub_passwd" ]; then ${ECHO} "${GREEN}[YES]${RESET}"; else ${ECHO} "${RED}[NO]${RESET}"; fi

${ECHO} -n "${CYAN}\n[IOMMU] --> ${RESET}"
b=$(cat /etc/default/grub | grep iommu=force)
if [ -n "$b" ]; then ${ECHO} "${GREEN}[YES]${RESET}"; else ${ECHO} "${RED}[NO]${RESET}"; fi

pause 

#KERNEL
${ECHO} "${PURPLE}------------------------------[${RESET}${BLUE} KERNEL ${RESET}${PURPLE}]------------------------------------------${RESET}"


${ECHO} -n "${CYAN}\n[Dynamic loading of kernel modules is disable] --> ${RESET}"
dynamic_loading_kernel_module=$(sysctl kernel.modules_disabled | grep 1)
if [ -n "$dynamic_loading_kernel_module" ]; then ${ECHO} "${GREEN}[YES]${RESET}"; else ${ECHO} "${RED}[NO]${RESET}"; fi

${ECHO} -n "${CYAN}\n[Yama security module is enable] --> ${RESET}"
yame=$(sysctl kernel.yama.ptrace_scope | grep 1 && sysctl kernel.yama.ptrace_scope | grep 2)
if [ -n "$yama" ]; then ${ECHO} "${GREEN}[YES]${RESET}"; else ${ECHO} "${RED}[NO]${RESET}"; fi 

${ECHO} -n "${CYAN}\n[Magic SysRq key] --> ${RESET}" && cat /proc/sys/kernel/sysrq

${ECHO} "${CYAN}\n[Sysctl]${RESET}"
#ANSSI
#https://www.ssi.gouv.fr/uploads/2016/01/linux_configuration-fr-v1.2.pdf
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

#OTHERS 
#https://www.ubuntupit.com/best-linux-hardening-security-tips-a-comprehensive-checklist/ (25.) (kernel.panic=10)
sysctl -a | grep -w kernel.panic

#https://www.cyberciti.biz/faq/linux-kernel-etcsysctl-conf-security-hardening/
sysctl -a | grep kernel.core_uses_pid
sysctl -a | grep fs.file-max

#https://obscurix.github.io/security/kernel-hardening.html
sysctl -a | grep kernel.unprivileged_bpf_disabled
sysctl -a | grep net.core.bpf_jit_harden
sysctl -a | grep kernel.kexec_load_disabled
sysctl -a | grep vm.mmap_rnd_bits
sysctl -a | grep vm.mmap_rnd_compat_bits
sysctl -a | grep kernel.unprivileged_userns_clone

pause 

#PARTITIONING
${ECHO} "${PURPLE}------------------------------[${RESET}${BLUE} PARTITIONING ${RESET}${PURPLE}]------------------------------------${RESET}"

${ECHO} "${CYAN}\n[Partitioning]${RESET}" && lsblk 

${ECHO} "${CYAN}\n[/etc/fstab]${RESET}" && egrep -v '^\s*#' /etc/fstab

# ${ECHO} "${CYAN}\n[SWAP]${RESET}" && swapon -s 

# ${ECHO} "${CYAN}\n[Partition encryption]${RESET}" && blkid /dev/nvme0n1 | grep --color=auto PTTYPE

pause

#PACKAGES
${ECHO} "${PURPLE}------------------------------[${RESET}${BLUE} PACKAGES ${RESET}${PURPLE}]----------------------------------------${RESET}"

${ECHO} -n "${CYAN}\n[fail2ban] --> ${RESET}"
fail2ban=$(${CHECK_PACKAGES} | grep fail2ban | awk '{print $1}' | grep ii)
if [ -n "$fail2ban" ]; then /etc/init.d/fail2ban status | grep Active; else ${ECHO} "${RED}[NOT FOUND]${RESET}"; fi

${ECHO} -n "${CYAN}\n[clamav] --> ${RESET}"
clamav=$(${CHECK_PACKAGES} | grep clamav | awk '{print $1}' | grep ii)
if [ -n "$clamav" ]; then ${ECHO} "${GREEN}[FOUND]${RESET}"; else ${ECHO} "${RED}[NOT FOUND]${RESET}"; fi

${ECHO} -n "${CYAN}\n[clamtk] --> ${RESET}"
clamtk=$(${CHECK_PACKAGES} | grep clamtk | awk '{print $1}' | grep ii)
if [ -n "$clamtk" ]; then ${ECHO} "${GREEN}[FOUND]${RESET}"; else ${ECHO} "${RED}[NOT FOUND]${RESET}"; fi

${ECHO} -n "${CYAN}\n[lynis] --> ${RESET}"
lynis=$(${CHECK_PACKAGES} | grep lynis | awk '{print $1}' | grep ii)
if [ -n "$lynis" ]; then ${ECHO} "${GREEN}[FOUND]${RESET}"; else ${ECHO} "${RED}[NOT FOUND]${RESET}"; fi

${ECHO} -n "${CYAN}\n[chkrootkit] --> ${RESET}"
chkrootkit=$(${CHECK_PACKAGES} | grep chkrootkit | awk '{print $1}' | grep ii)
if [ -n "$chkrootkit" ]; then ${ECHO} "${GREEN}[FOUND]${RESET}"; else ${ECHO} "${RED}[NOT FOUND]${RESET}"; fi

${ECHO} -n "${CYAN}\n[rkhunter] --> ${RESET}"
rkhunter=$(${CHECK_PACKAGES} | grep rkhunter | awk '{print $1}' | grep ii)
if [ -n "$rkhunter" ]; then ${ECHO} "${GREEN}[FOUND]${RESET}"; else ${ECHO} "${RED}[NOT FOUND]${RESET}"; fi

${ECHO} -n "${CYAN}\n[tiger] --> ${RESET}"
tiger=$(${CHECK_PACKAGES} | grep tiger | awk '{print $1}' | grep ii)
if [ -n "$tiger" ]; then ${ECHO} "${GREEN}[FOUND]${RESET}"; else ${ECHO} "${RED}[NOT FOUND]${RESET}"; fi

${ECHO} -n "${CYAN}\n[yasat] --> ${RESET}"
yasat=$(${CHECK_PACKAGES} | grep yasat | awk '{print $1}' | grep ii)
if [ -n "$yasat" ]; then ${ECHO} "${GREEN}[FOUND]${RESET}"; else ${ECHO} "${RED}[NOT FOUND]${RESET}"; fi

${ECHO} -n "${CYAN}\n[iptables] --> ${RESET}"
iptables=$(${CHECK_PACKAGES} | grep iptables | awk '{print $1}' | grep ii)
if [ -n "$iptables" ]; then ${ECHO} "${GREEN}[FOUND]${RESET}"; else ${ECHO} "${RED}[NOT FOUND]${RESET}"; fi

${ECHO} -n "${CYAN}\n[ufw] --> ${RESET}"
ufw=$(${CHECK_PACKAGES} | grep ufw | awk '{print $1}' | grep ii)
if [ -n "$ufw" ]; then ${ECHO} "${GREEN}[FOUND]${RESET}"; else ${ECHO} "${RED}[NOT FOUND]${RESET}"; fi

${ECHO} -n "${CYAN}\n[nftables] --> ${RESET}"
nftables=$(${CHECK_PACKAGES} | grep nftables | awk '{print $1}' | grep ii)
if [ -n "$nftables" ]; then ${ECHO} "${GREEN}[FOUND]${RESET}"; else ${ECHO} "${RED}[NOT FOUND]${RESET}"; fi

${ECHO} -n "${CYAN}\n[firewalld] --> ${RESET}"
firewalld=$(${CHECK_PACKAGES} | grep firewalld | awk '{print $1}' | grep ii)
if [ -n "$firewalld" ]; then ${ECHO} "${GREEN}[FOUND]${RESET}"; else ${ECHO} "${RED}[NOT FOUND]${RESET}"; fi

${ECHO} -n "${CYAN}\n[bpfilter] --> ${RESET}"
bpfilter=$(${CHECK_PACKAGES} | grep bpfilter | awk '{print $1}' | grep ii)
if [ -n "$bpfilter" ]; then ${ECHO} "${GREEN}[FOUND]${RESET}"; else ${ECHO} "${RED}[NOT FOUND]${RESET}"; fi

pause 

#NETWORK
${ECHO} "${PURPLE}------------------------------[${RESET}${BLUE} NETWORK ${RESET}${PURPLE}]-----------------------------------------${RESET}"

${ECHO} "${CYAN}\n[Ipv4]${RESET}"
#ANSSI
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


#OTHERS 
#https://www.cyberciti.biz/faq/linux-kernel-etcsysctl-conf-security-hardening/
sysctl -a | grep net.ipv4.tcp_synack_retries
sysctl -a | grep net.ipv4.icmp_echo_ignore_broadcasts

#https://obscurix.github.io/security/kernel-hardening.html
sysctl -a | grep net.ipv4.icmp_echo_ignore_all
sysctl -a | grep net.ipv4.tcp_timestamps
sysctl -a | grep net.ipv4.tcp_sack


${ECHO} "${CYAN}\n[Ipv6]${RESET}"
#ANSSI
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

#OTHERS 
#https://www.cyberciti.biz/faq/linux-kernel-etcsysctl-conf-security-hardening/
sysctl -a | grep net.ipv6.conf.default.dad_transmits

${ECHO} "${CYAN}\n[OpenPorts]${RESET}" && ss -tulpn # OR netstat -antp

${ECHO} "${CYAN}\n[TCP Wrappers]${RESET}" && ldd /sbin/sshd | grep libwrap


pause 

#SSH
${ECHO} "${PURPLE}------------------------------[${RESET}${BLUE} SSH ${RESET}${PURPLE}]---------------------------------------------${RESET}\n"

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

#SUDO 
${ECHO} "${PURPLE}------------------------------[${RESET}${BLUE} SUDO ${RESET}${PURPLE}]--------------------------------------------${RESET}"

${ECHO} "${CYAN}\n[Sudo version]${RESET}" && sudo -V | grep -m1 "" 

${ECHO} "${CYAN}\n[Sudo privileges]${RESET}" && ls -lrtha /usr/bin/sudo

${ECHO} "${CYAN}\n[Sudo -l]${RESET}" && sudo -l 

pause 

#OTHERS 
${ECHO} "${PURPLE}------------------------------[${RESET}${BLUE} OTHERS ${RESET}${PURPLE}]------------------------------------------${RESET}"

${ECHO} -n "${CYAN}\n[SELinux] --> ${RESET}" && sestatus 

${ECHO} -n "${CYAN}\n[AppArmor] --> ${RESET}" && aa-status

${ECHO} -n "${CYAN}\n[Access to virtual consoles] --> ${RESET}"
virtual_consoles=$(grep "^[^#;]" /etc/pam.d/login | grep pam_securetty.so)
if [ -n "$virtual_consoles" ]; then ${ECHO} "${GREEN}[YES]${RESET}"; else ${ECHO} "${GREEN}[NO]${RESET}"; fi

#Use a distribution with an init system other than systemd. systemd contains a lot of unnecessary attack surface and inserts a considerable amount of complexity into the most privileged user space component
${ECHO} -n "${CYAN}\n[Init system] --> ${RESET}" && stat /sbin/init | grep File: | sed 's/ //g' | cut -d: -f2-

# ${ECHO} "${CYAN}\n[Multi-user.target services]${RESET}"
# ls -lrtha /etc/systemd/system/multi-user.target.wants/

${ECHO} "${CYAN}\n[/boot]${RESET}"

${ECHO} "${PURPLE}[ls -lrtha /boot/]${RESET}" && ls --color=auto -lrtha /boot/

${ECHO} "${PURPLE}[ls -lrth / | grep boot]${RESET}" && ls -lrth / | grep --color=auto boot

${ECHO} "${CYAN}\n[Accounts With Empty Passwords]${RESET}"
empty_passwd=$(awk -F: '($2 == "") {print}' /etc/shadow)
if [ -n "$empty_passwd" ]; then ${ECHO} "$empty_passwd"; else ${ECHO} "${GREEN}[NO]${RESET}"; fi

${ECHO} "${CYAN}\n[Nologin accounts]${RESET}" && cat /etc/passwd | grep -v nologin

${ECHO} "${CYAN}\n[$USER chage details]${RESET}" && chage -l $USER

${ECHO} "${CYAN}\n[/etc/login.defs ]${RESET}" && egrep -v '^\s*#' /etc/login.defs | grep PASS

${ECHO} "${CYAN}\n[Accounts UID Set To 0]${RESET}"
uid=$(awk -F: '($3 == "0") {print}' /etc/passwd)
if [ -n "$uid" ]; then ${ECHO} "$uid"; else ${ECHO} "[0]"; fi

${ECHO} "${CYAN}\n[Umask]${RESET}" && umask

${ECHO} "${CYAN}\n[etc/pam.d/common-password]${RESET}" && grep -v '^\s*#' /etc/pam.d/common-password

#${ECHO} "${CYAN}\n[etc/security/limits.conf]${RESET}" && grep -v '^\s*#' /etc/security/limits.conf

${ECHO} "${CYAN}\n[Sensitives files]${RESET}"
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

${ECHO} "${CYAN}\n[CRON]${RESET}" && grep -v '^\s*#' /etc/crontab
