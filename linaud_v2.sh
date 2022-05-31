CYAN='\033[1;36m'
RESET='\033[0m'

echo "${CYAN}\n[/boot/grub]${RESET}"
ls -l /boot/grub

echo "${CYAN}\n[SSH]${RESET}"

cat /etc/ssh/sshd_config | grep PermitRootLogin
cat /etc/ssh/sshd_config | grep PermitEmptyPasswords
cat /etc/ssh/sshd_config | grep DefaultPort
cat /etc/ssh/sshd_config | grep Protocol
cat /etc/ssh/sshd_config | grep ClientAliveInterval
cat /etc/ssh/sshd_config | grep ClientAliveCountMax
cat /etc/ssh/sshd_config | grep AllowUsers
cat /etc/ssh/sshd_config | grep AllowGroups
cat /etc/ssh/sshd_config | grep X11Forwarding

echo -n "${CYAN}\n[SELinux] --> ${RESET}"
sestatus 

echo -n "${CYAN}\n[AppArmor] --> ${RESET}"
aa-status

echo "${CYAN}\n[OpenPorts]${RESET}"
netstat -antp

echo "${CYAN}\n[etc/pam.d/common-password]${RESET}"
grep -v '^\s*#' /etc/pam.d/common-password

#echo "${CYAN}\n[etc/security/limits.conf]${RESET}"
#grep -v '^\s*#' /etc/security/limits.conf


echo "${CYAN}\n[Sensitives files]${RESET}"
ls -l /etc/sudoers 
ls -l /etc/shadow
ls -l /etc/gshadow
ls -l /etc/passwd
ls -l /etc/group
ls -l /proc/cmdline
#ls -l /etc/rc.*
ls -l /etc/profile
ls -l /etc/hosts
ls -l /etc/resolv.conf

echo "${CYAN}\n[CRON]${RESET}"
grep -v '^\s*#' /etc/crontab


echo "${CYAN}\n[iptables]${RESET}"
iptables=$(dpkg -l | grep iptables)
if [ -n "$iptables" ]; then
    echo "Package is install"
else
    echo "Package is not install"
fi

echo "${CYAN}\n[ufw]${RESET}"
ufw=$(dpkg -l | grep ufw)
if [ -n "$ufw" ]; then
    echo "Package is install"
else
    echo "Package is not install"
fi

echo "${CYAN}\n[nftables]${RESET}"
nftables=$(dpkg -l | grep nftables)
if [ -n "$nftables" ]; then
    echo "Package is install"
else
    echo "Package is not install"
fi

echo "${CYAN}\n[firewalld]${RESET}"
firewalld=$(dpkg -l | grep firewalld)
if [ -n "$firewalld" ]; then
    echo "Package is install"
else
    echo "Package is not install"
fi

echo "${CYAN}\n[bpfilter]${RESET}"
bpfilter=$(dpkg -l | grep bpfilter)
if [ -n "$bpfilter" ]; then
    echo "Package is install"
else
    echo "Package is not install"
fi


