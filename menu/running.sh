#!/bin/bash
red="\e[1;31m"
green="\e[0;32m"
NC="\e[0m"
clear
GitUser="RazVpn"
# VPS Information
Checkstart1=$(ip route | grep default | cut -d ' ' -f 3 | head -n 1);
if [[ $Checkstart1 == "venet0" ]]; then 
    clear
	  lan_net="venet0"
    typevps="OpenVZ"
    sleep 1
else
    clear
		lan_net="eth0"
    typevps="KVM"
    sleep 1
fi
MYIP=$(wget -qO- icanhazip.com);
echo -e "\e[32mloading...\e[0m"
clear
echo -e ""
echo -e "              \e[0;32m[\e[1;36mSYSTEM STATUS INFORMATION\e[0;32m]\e[0m"
echo -e "             \e[0;34m=============================\e[0m"
echo -e ""
echo -e "\e[1;33mSTATUS SSH & OPEN VPN:\e[0m"
echo -e "\e[0;34m-----------------------\e[0m"
status="$(systemctl show ssh.service --no-page)"
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)
if [ "${status_text}" == "active" ]
then
echo -e " Open SSH                : "$green"running"$NC" ✓"
else
echo -e " Open SSH                : "$red"not running (Error)"$NC" "
fi
status="$(systemctl show --now openvpn-server@server-tcp-1194 --no-page)"
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)
if [ "${status_text}" == "active" ]
then
echo -e " OpenVPN TCP             : "$green"running"$NC" ✓"
else
echo -e " OpenVPN TCP             : "$red"not running (Error)"$NC" "
fi
status="$(systemctl show --now openvpn-server@server-udp-2200 --no-page)"
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)
if [ "${status_text}" == "active" ]
then
echo -e " OpenVPN UDP             : "$green"running"$NC" ✓"
else
echo -e " OpenVPN UDP             : "$red"not running (Error)"$NC" "
fi
status="$(systemctl show stunnel4.service --no-page)"
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)
if [ "${status_text}" == "active" ]
then
echo -e " Stunnel(SSL)            : "$green"running"$NC" ✓"
else
echo -e " Stunnel(SSL)            : "$red"not running (Error)"$NC" "
fi
status="$(systemctl show dropbear.service --no-page)"
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)
if [ "${status_text}" == "active" ]
then
echo -e " DropBear                : "$green"running"$NC" ✓"
else
echo -e " DropBear                : "$red"not running (Error)"$NC" "
fi

echo -e ""
echo -e "\e[1;33mSTATUS WS TLS:\e[0m"
echo -e "\e[0;34m-------------\e[0m"
status="$(systemctl show xray.service --no-page)"
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)
if [ "${status_text}" == "active" ]
then
echo -e " Xray Vless Ws Tls       : "$green"running"$NC" ✓"
else
echo -e " Xray Vless Ws Tls       : "$red"not running (Error)"$NC" "
fi
status="$(systemctl show xray.service --no-page)"
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)
if [ "${status_text}" == "active" ]
then
echo -e " Xray Vmess Ws Tls       : "$green"running"$NC" ✓"
else
echo -e " Xray Vmess Ws Tls       : "$red"not running (Error)"$NC" "
fi
status="$(systemctl show xray.service --no-page)"
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)
if [ "${status_text}" == "active" ]
then
echo -e " Xray Trojan Ws Tls        : "$green"running"$NC" ✓"
else
echo -e " Xray Trojan Ws Tls        : "$red"not running (Error)"$NC" "
fi
echo -e "\e[1;33mSTATUS NTLS :\e[0m"
echo -e "\e[0;34m-----------------\e[0m"
status="$(systemctl show xray@v2ray-nontls.service --no-page)"
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)
if [ "${status_text}" == "active" ]
then
echo -e " Xray Vmess Ws None Tls  : "$green"running"$NC" ✓"
else
echo -e " Xray Vmess Ws None Tls  : "$red"not running (Error)"$NC" "
fi

status="$(systemctl show xray@vless-nontls.service --no-page)"
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)
if [ "${status_text}" == "active" ]
then
echo -e " Xray Vless Ws None Tls  : "$green"running"$NC" ✓"
else
echo -e " Xray Vless Ws None Tls  : "$red"not running (Error)"$NC" "
fi
echo -e "\e[1;33mSTATUS GRPC :\e[0m"
echo -e "\e[0;34m-----------------\e[0m"
status="$(systemctl show xray@vless-grpc --no-page)"                                      
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)                     
if [ "${status_text}" == "active" ] 
then
echo -e " Xray Vless Grpc    : "$green"running"$NC" ✓"
else
echo -e " Xray Vless Grpc       : "$red"not running (Error)"$NC" "
fi
status="$(systemctl show xray@vless-grpc --no-page)"                                      
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)                     
if [ "${status_text}" == "active" ] 
then
echo -e " Xray Vmess Grpc    : "$green"running"$NC" ✓"
else
echo -e " Xray Vmess Grpc       : "$red"not running (Error)"$NC" "
fi
status="$(systemctl show xray@vless-grpc --no-page)"                                      
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)                     
if [ "${status_text}" == "active" ] 
then
echo -e " Xray Trojan Grpc    : "$green"running"$NC" ✓"
else
echo -e " Xray Trojan Grpc       : "$red"not running (Error)"$NC" "
fi
echo -e ""
echo -e "\e[1;33mSTATUS TROJAN :\e[0m"
echo -e "\e[0;34m-----------------\e[0m"


echo -e ""
echo -e "\e[1;33mSTATUS NGIX & SQUID:\e[0m"
echo -e "\e[0;34m--------------------\e[0m"
status="$(systemctl show nginx.service --no-page)"
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)
if [ "${status_text}" == "active" ]
then
echo -e " Nginx                   : "$green"running"$NC" ✓"
else
echo -e " Nginx                   : "$red"not running (Error)"$NC" "
fi
status="$(systemctl show squid.service --no-page)"
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)
if [ "${status_text}" == "active" ]
then
echo -e " Squid                   : "$green"running"$NC" ✓"
else
echo -e " Squid                   : "$red"not running (Error)"$NC" "
fi
echo -e "\e[0;34m-----------------------------------------------------------\e[0m"
echo -e ""
echo -e "${green}JIKA TERDAPAT NOT RUNNING, PLEASE REPORT TO ADMIN FOR FIX$NC"
echo -e "${green}Report to Ichikaa @Ichikaa1$NC"
