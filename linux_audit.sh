RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
PURPLE='\033[1;35m'
CYAN='\033[1;36m'
WHITE='\033[1;37m'
GREY='\033[1;38m'
RESET='\033[0m'



echo " 
${CYAN}
██      ██ ███    ██  █████  ██    ██ ██████  
██      ██ ████   ██ ██   ██ ██    ██ ██   ██ 
██      ██ ██ ██  ██ ███████ ██    ██ ██   ██ 
██      ██ ██  ██ ██ ██   ██ ██    ██ ██   ██ 
███████ ██ ██   ████ ██   ██  ██████  ██████  
${RESET}
"




#######################################################
echo "${BLUE}\n[+] DETAILS ${RESET}"
echo "---------------------------------------------"

echo -n "${WHITE}OS : ${RESET}" 
cat /etc/os-release | grep PRETTY | cut -d= -f2-

echo -n "${WHITE}Host : ${RESET}" 
cat /proc/sys/kernel/hostname

echo -n "${WHITE}Kernel : ${RESET}" 
uname -r 

echo -n "${WHITE}Uptime : ${RESET}"
uptime | cut -c 15-18

echo -n "${WHITE}Packages : ${RESET}"
dpkg --list | wc --lines

echo -n "${WHITE}Shell : ${RESET}"
$SHELL --version

echo -n "${WHITE}Resolution : ${RESET}"
xdpyinfo | awk '/dimensions/ {print $2}'
#######################################################




#######################################################
echo "${GREEN}\n[+] START-UP PROCESS ${RESET}"
echo -n "---------------------------------------------"
echo "${CYAN}\n[GRUB protection]${RESET}"
ls -lrtha /etc/grub.d/

echo -n "${CYAN}\n[GRUB password] --> ${RESET}"
z=$(cat /boot/grub/grub.cfg | grep password)
if [ -n "$z" ]; then
    echo "${GREEN}[YES]${RESET}"
else
    echo "${RED}[NO]${RESET}"
fi

echo -n "${CYAN}\n[IOMMU] --> ${RESET}"
o=$(cat /etc/default/grub | grep iommu=force)
if [ -n "$o" ]; then
    echo "${GREEN}[YES]${RESET}"
else
    echo "${RED}[NO]${RESET}"
fi

echo -n "${CYAN}\n[Dynamic loading of kernel modules] --> ${RESET}"
l=$(sysctl kernel.modules_disabled | grep 1)
if [ -n "$l" ]; then
    echo "${GREEN}[YES]${RESET}"
else
    echo "${RED}[NO]${RESET}"
fi

echo -n "${CYAN}\n[Access to virtual consoles] --> ${RESET}"
y=$(grep "^[^#;]" /etc/pam.d/login | grep pam_securetty.so)
if [ -n "$y" ]; then
    echo "${GREEN}[YES]${RESET}"
else
    echo "${GREEN}[NO]${RESET}"
fi

echo -n "${CYAN}\n[Magic SysRq key] --> ${RESET}"
cat /proc/sys/kernel/sysrq

#Use a distribution with an init system other than systemd. systemd contains a lot of unnecessary attack surface and inserts a considerable amount of complexity into the most privileged user space component
echo -n "${CYAN}\n[Init system] --> ${RESET}"
stat /sbin/init | grep File: | sed 's/ //g' | cut -d: -f2-

# echo "${CYAN}\n[Multi-user.target services]${RESET}"
# ls -lrtha /etc/systemd/system/multi-user.target.wants/





#######################################################

echo "${BLUE}\n[+] SYSTEM ${RESET}"
echo -n "---------------------------------------------"

echo -n "${CYAN}\n[CPU flags]${RESET}"
echo -n "${CYAN}\n[pae] --> ${RESET}"
x=$(grep ^flags /proc/cpuinfo | head -n1 | egrep --color=auto 'pae')
if [ -n "$x" ]; then
    echo -n "${GREEN}YES${RESET}"
else
    echo -n "${RED}NO${RESET}"
fi

echo -n "${CYAN}\n[nx]  --> ${RESET}"
x=$(grep ^flags /proc/cpuinfo | head -n1 | egrep --color=auto 'nx')
if [ -n "$x" ]; then
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
a=$(awk -F: '($2 == "") {print}' /etc/shadow)
if [ -n "$a" ]; then
    echo "$a"
else
    echo "${GREEN}[NO]${RESET}"
fi

echo "${CYAN}\n[Nologin accounts]${RESET}"
cat /etc/passwd | grep -v nologin

echo "${CYAN}\n[$USER chage details]${RESET}"
chage -l $USER

echo "${CYAN}\n[/etc/login.defs ]${RESET}"
cat /etc/login.defs | grep --color=auto PASS

echo "${CYAN}\n[Accounts UID Set To 0]${RESET}"
b=$(awk -F: '($3 == "0") {print}' /etc/passwd)

if [ -n "$b" ]; then
    echo "$b"
else
    echo "[0]"
fi


echo "${CYAN}\n[Sudo privileges]${RESET}"
ls -lrtha /usr/bin/sudo

echo "${CYAN}\n[Umask]${RESET}"
umask

echo "${CYAN}\n[Ipv6]${RESET}"
sysctl -a| grep --color=auto disable_ipv6


echo "${CYAN}\n[fail2ban]${RESET}"
c=$(dpkg -l | grep fail2ban)

if [ -n "$c" ]; then
    /etc/init.d/fail2ban status | grep Active
else
    echo "Package is not install"
fi






