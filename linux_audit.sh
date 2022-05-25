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


echo "${CYAN}\nAccounts With Empty Passwords${RESET}"

a=$(awk -F: '($2 == "") {print}' /etc/shadow)

if [ -n "$a" ]; then
    echo "$a"
else
    echo "[0]"
fi



echo "${CYAN}\nUID Set To 0${RESET}"

b=$(awk -F: '($3 == "0") {print}' /etc/passwd)

if [ -n "$b" ]; then
    echo "$b"
else
    echo "[0]"
fi



echo "${CYAN}\nCheck Ipv6${RESET}"
sysctl -a|grep disable_ipv6


echo "${CYAN}\nCheck fail2ban${RESET}"

c=$(dpkg -l | grep fail2ban)

if [ -n "$c" ]; then
    /etc/init.d/fail2ban status | grep Active
else
    echo "Package is not install"
fi




