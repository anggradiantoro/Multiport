#!/bin/bash
clear
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
uuid=$(cat /etc/trojan/uuid.txt)
source /var/lib/premium-script/ipvps.conf
if [[ "$IP" = "" ]]; then
domain=$(cat /etc/v2ray/domain)
else
domain=$IP
fi
# PROVIDED
creditt=$(cat /root/provided)
tr="$(cat ~/log-install.txt | grep -w "XRAY TROJAN WS TLS" | cut -d: -f2|sed 's/ //g')"
trgrpc="$(cat ~/log-install.txt | grep -w "XRAY TROJAN GRPC" | cut -d: -f2|sed 's/ //g')"
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${user_EXISTS} == '0' ]]; do
		read -rp "Password: " -e user
		user_EXISTS=$(grep -w $user /etc/trojan/akun.conf | wc -l)

		if [[ ${user_EXISTS} == '1' ]]; then
			echo ""
			echo "A client with the specified name was already created, please choose another name."
			exit 1
		fi
	done
read -p "Expired (days): " masaaktif
sed -i '/"'""$uuid""'"$/a\,"'""$user""'"' /etc/trojan/config.json
sed -i '/#trojangrpc$/a\### '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$user""'"' /etc/xray/config.json
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
hariini=`date -d "0 days" +"%Y-%m-%d"`
echo -e "### $user $exp" >> /etc/trojan/akun.conf
systemctl restart trojan
trojanlink1="trojan://${uuid}@${domain}:${tr}?type=ws&security=tls&host=${domain}&path=/trojanws&sni=bug.com#TROJAN_TLS_${user}"
trojanlink2="trojan://${uuid}@${domain}:${trgrpc}?allowInsecure=1&security=tls&type=grpc&serviceName=/trojangrpc&sni=bug.com#TROJAN_GRPC_${user}"

clear
echo -e ""
echo -e "══════════════════[ XRAY  TROJAN ]════════════════"
echo -e "Remarks        : ${user}"
echo -e "Expired On     : $exp"
echo -e "Host/IP             : ${domain}"
echo -e "Port WS NTLS          : ${tr}"
echo -e "Port  GRPC       : ${trgrpc}"
echo -e "Key            : ${user}"
echo -e "═════════════════════════════════════════════"
echo -e "Link WS TLS       : ${trojanlink1}"
echo -e ""
echo -e "═════════════════════════════════════════════"
echo -e "Link GRPC         : ${trojanlink2}"
echo -e ""
echo -e "═════════════════════════════════════════════"
echo -e "Created On        : $hariini"
echo -e "Expired On        : $exp"
echo -e "Premium By $creditt"
echo -e "═════════════════════════════════════════════"
echo ""
echo -e 
echo ""
read -n 1 -s -r -p "Press any key to back on menu"
menu