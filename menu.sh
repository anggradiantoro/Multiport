#!/bin/bash
GitUser="RazVpn"
Repo="ipm"
clear
red='\e[1;31m'
green='\e[0;32m'
blue='\e[0;34m'
blue_b='\e[0;94m'
NC='\e[0m'
MYIP=$(wget -qO- icanhazip.com);
IZIN=$(curl https://raw.githubusercontent.com/RazVpn/ipm/main/IP/REGIP | grep $MYIP | awk '{print $4}')
if [ $MYIP = $IZIN ]; then
    echo -e ""
    clear
else
  echo -e ""
    echo -e "${green}ACCESS DENIED...PM TELEGRAM OWNER${NC}"
    exit 1
fi
echo -e " "
IPVPS=$(curl -s icanhazip.com)
DOMAIN=$(cat /etc/v2ray/domain)
cekxray="$(openssl x509 -dates -noout < /etc/v2ray/v2ray.crt)"                                      
expxray=$(echo "${cekxray}" | grep 'notAfter=' | cut -f2 -d=)
name=$(curl -sS https://raw.githubusercontent.com/${GitUser}/${Repo}/main/IP/REGIP | grep $IPVPS | awk '{print $2}')
exp=$(curl -sS https://raw.githubusercontent.com/${GitUser}/${Repo}/main/IP/REGIP | grep $IPVPS | awk '{print $3}')

echo -e  "${blue_b}╔═══╗╔═══╗╔═══╗╔══╗╔═══╗╔════╗  ╔═══╗╔═══╗╔═══╗╔═╗╔═╗╔══╗╔╗ ╔╗╔═╗╔═╗"${NC}
echo -e  "${blue_b}║╔═╗║║╔═╗║║╔═╗║╚╣╠╝║╔═╗║║╔╗╔╗║  ║╔═╗║║╔═╗║║╔══╝║║╚╝║║╚╣╠╝║║ ║║║║╚╝║║"${NC}
echo -e  "${blue_b}╚══╗║║║ ╔╗║╔╗╔╝ ║║ ║╔══╝  ║║    ║╔══╝║╔╗╔╝║╔══╝║║║║║║ ║║ ║║ ║║║║║║║║"${NC}
echo -e  "${blue_b}║╚═╝║║╚═╝║║║║╚╗╔╣╠╗║║    ╔╝╚╗   ║║   ║║║╚╗║╚══╗║║║║║║╔╣╠╗║╚═╝║║║║║║║"${NC}
echo -e  "${blue_b}╚═══╝╚═══╝╚╝╚═╝╚══╝╚╝    ╚══╝   ╚╝   ╚╝╚═╝╚═══╝╚╝╚╝╚╝╚══╝╚═══╝╚╝╚╝╚╝"${NC}
echo -e  " "
echo -e  " ${green}IP VPS NUMBER               : $IPVPS${NC}"
echo -e  " ${green}DOMAIN                      : $DOMAIN${NC}"
echo -e  " ${green}OS VERSION                  : `hostnamectl | grep "Operating System" | cut -d ' ' -f5-`"${NC}
echo -e  " ${green}KERNEL VERSION              : `uname -r`${NC}"
echo -e  " ${green}EXP DATE CERT V2RAY/XRAY    : $expxray${NC}"
echo -e  " ${green}CLIENT NAME                 : $name${NC}"
echo -e  " ${green}EXP SCRIPT ACCSESS          : $exp${NC}"
echo -e  " "
echo -e  " ═════════════════════════════════════════════════════════════════ "
echo -e  " ${green}MAIN MENU${NC} "                                       
echo -e  " ═════════════════════════════════════════════════════════════════ "
echo -e  " [  1 ] SSH & OPENVPN" 
echo -e  " [  2 ] XRAY CORE" 
echo -e  " [  3 ] TROJAN GFW"  
echo -e  "  "
echo -e  " ═════════════════════════════════════════════════════════════════ "
echo -e  " ${green}SYSTEM MENU${NC} "       
echo -e  " ═════════════════════════════════════════════════════════════════ "                            
echo -e  " [  4 ] ADD/CHANGE DOMAIN VPS"
echo -e  " [  5 ] CHANGE PORT SERVICE"
echo -e  " [  6 ] CHANGE DNS SERVER"
echo -e  " [  7 ] RENEW V2RAY AND XRAY CERTIFICATION"
echo -e  " [  8 ] WEBMIN MENU"
echo -e  " [  9 ] CHECK RAM USAGE"
echo -e  " [ 10 ] REBOOT VPS"
echo -e  " [ 11 ] SPEEDTEST VPS"
echo -e  " [ 12 ] DISPLAY SYSTEM INFORMATION"
echo -e  " [ 13 ] CHECK STREAM GEO LOCATION"
echo -e  " [ 14 ] CHECK SERVICE ERROR"
echo -e  " [ 15 ] UPDATE SCRIPT"
echo -e  "  "
echo -e  " ═════════════════════════════════════════════════════════════════" 
echo -e  " ${green}[  0 ] EXIT MENU${NC}  "
echo -e  " ═════════════════════════════════════════════════════════════════"
echo -e  "  "
echo -e "\e[1;31m"
read -p  "     Please select an option :  " menu
echo -e "\e[0m"
 case $menu in
   1)
   mssh
   ;;
   2)
   mxraycore
   ;;
   3)
   mtrojan
   ;;
   4)
   add-host
   ;;
   5)
   change
   ;;
   6)
   mdns
   ;;
   7)
   recert-xrayv2ray
   ;;
   8)
   wbmn
   ;;
   9)
   ram
   ;;
   10)
   reboot
   ;;
   11)
   speedtest
   ;;
   12)
   info
   ;;
   13)
   nf
   ;;
   14)
   checksystem  
   ;;
   15)
   update  
   ;;   
   0)
   sleep 0.5
   clear
   ;;
   *)
   echo -e "ERROR!! Please Enter an Correct Number"
   sleep 1
   clear
   menu
   ;;
   esac
