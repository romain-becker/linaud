RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
PURPLE='\033[1;35m'
CYAN='\033[1;36m'
WHITE='\033[1;37m'
GREY='\033[1;38m'
RESET='\033[0m'

# https://www.cyberciti.biz/tips/linux-security.html


echo "${CYAN}\n[Grub protection]${RESET}"
ls -lrtha /etc/grub.d/

echo "${CYAN}\n[Grub password]${RESET}"
z=$(cat /boot/grub/grub.cfg | grep password)

if [ -n "$z" ]; then
    echo "${GREEN}OK${RESET}"
else
    echo "${RED}NO PASSWD${RESET}"
fi

echo "${CYAN}\n[IOMMU]${RESET}"
cat /etc/default/grub | grep --color=auto GRUB_CMDLINE_LINUX

echo "${CYAN}\n[Dynamic loading of kernel modules]${RESET}"
sysctl kernel.modules_disabled

echo "${CYAN}\n[Access to virtual consoles]${RESET}"
y=$(grep "^[^#;]" /etc/pam.d/login | grep pam_securetty.so)

if [ -n "$y" ]; then
    echo "$y"
else
    echo "${GREEN}NO${RESET}"
fi

echo "${CYAN}\n[Magic SysRq key]${RESET}"
cat /proc/sys/kernel/sysrq

# echo "${CYAN}\n[Multi-user.target services]${RESET}"
# ls -lrtha /etc/systemd/system/multi-user.target.wants/

echo "${CYAN}\n[CPU flags pae & nx]${RESET}"
grep ^flags /proc/cpuinfo | head -n1 | egrep --color=auto ' (pae|nx) '

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
    echo "[0]"
fi


echo "${CYAN}\n[Accounts UID Set To 0]${RESET}"
b=$(awk -F: '($3 == "0") {print}' /etc/passwd)

if [ -n "$b" ]; then
    echo "$b"
else
    echo "[0]"
fi

echo "${CYAN}\n[Ipv6]${RESET}"
sysctl -a| grep --color=auto disable_ipv6


echo "${CYAN}\n[fail2ban]${RESET}"
c=$(dpkg -l | grep fail2ban)

if [ -n "$c" ]; then
    /etc/init.d/fail2ban status | grep Active
else
    echo "Package is not install"
fi






