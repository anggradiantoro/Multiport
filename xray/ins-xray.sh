#!/bin/bash
#
#wget https://github.com/${GitUser}/
GitUser="RazVpn"
Repo="Multiport"
Dir="xray"
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
# ==================================================

# // Install 
domain=$(cat /etc/xray/domain)
apt-get install netfilter-persistent -y
apt install curl socat xz-utils wget apt-transport-https gnupg gnupg2 gnupg1 dnsutils lsb-release -y 
apt install socat cron bash-completion ntpdate -y
ntpdate pool.ntp.org
apt -y install chrony
timedatectl set-ntp true
systemctl enable chronyd && systemctl restart chronyd
systemctl enable chrony && systemctl restart chrony
timedatectl set-timezone Asia/Kuala_Lumpur
chronyc sourcestats -v
chronyc tracking -v
ufw disable
date

# // Nginx
installType='apt -y install'
source /etc/os-release
release=$ID
ver=$VERSION_ID

if [[ "${release}" == "debian" ]]; then
    sudo apt install gnupg2 ca-certificates lsb-release -y 
    echo "deb http://nginx.org/packages/mainline/debian $(lsb_release -cs) nginx" | sudo tee /etc/apt/sources.list.d/nginx.list 
    echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" | sudo tee /etc/apt/preferences.d/99nginx 
    curl -o /tmp/nginx_signing.key https://nginx.org/keys/nginx_signing.key 
    # gpg --dry-run --quiet --import --import-options import-show /tmp/nginx_signing.key
    sudo mv /tmp/nginx_signing.key /etc/apt/trusted.gpg.d/nginx_signing.asc
    sudo apt update 
                apt -y install nginx

elif [[ "${release}" == "ubuntu" ]]; then
    sudo apt install gnupg2 ca-certificates lsb-release -y 
    echo "deb http://nginx.org/packages/mainline/ubuntu $(lsb_release -cs) nginx" | sudo tee /etc/apt/sources.list.d/nginx.list
    echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" | sudo tee /etc/apt/preferences.d/99nginx 
    curl -o /tmp/nginx_signing.key https://nginx.org/keys/nginx_signing.key
    # gpg --dry-run --quiet --import --import-options import-show /tmp/nginx_signing.key
    sudo mv /tmp/nginx_signing.key /etc/apt/trusted.gpg.d/nginx_signing.asc
    sudo apt update 
                apt -y install nginx
fi

systemctl daemon-reload
systemctl enable nginx
ufw disable
touch /etc/nginx/conf.d/alone.conf
cat <<EOF >>/etc/nginx/conf.d/alone.conf
server {
             listen 80;
             listen [::]:80;
             listen 443 ssl http2 reuseport;
             listen [::]:443 http2 reuseport; 
             server_name ${domain};
             ssl_certificate /etc/jinggovpn/tls/xray.crt;
             ssl_certificate_key /etc/jinggovpn/tls/xray.key;
             ssl_ciphers EECDH+CHACHA20:EECDH+CHACHA20-draft:EECDH+ECDSA+AES128:EECDH+aRSA+AES128:RSA+AES128:EECDH+ECDSA+AES256:EECDH+aRSA+AES256:RSA+AES256:EECDH+ECDSA+3DES:EECDH+aRSA+3DES:RSA+3DES:!MD5;
             ssl_protocols TLSv1.1 TLSv1.2 TLSv1.3;
             root /usr/share/nginx/html;

             location = /vless {
                       proxy_redirect off;
                       proxy_pass http://127.0.0.1:14016;
                       proxy_http_version 1.1;
             proxy_set_header X-Real-IP aaa;
             proxy_set_header X-Forwarded-For bbb;
             proxy_set_header Upgrade ddd;
             proxy_set_header Connection "upgrade";
             proxy_set_header Host ccc;
 }
             location = /vmess {
                       proxy_redirect off;
                       proxy_pass http://127.0.0.1:23456;
                       proxy_http_version 1.1;
             proxy_set_header X-Real-IP aaa;
             proxy_set_header X-Forwarded-For bbb;
             proxy_set_header Upgrade ddd;
             proxy_set_header Connection "upgrade";
             proxy_set_header Host ccc;
 }
             location = /trojan-ws {
                       proxy_redirect off;
                       proxy_pass http://127.0.0.1:25432;
                       proxy_http_version 1.1;
             proxy_set_header X-Real-IP aaa;
             proxy_set_header X-Forwarded-For bbb;
             proxy_set_header Upgrade ddd;
             proxy_set_header Connection "upgrade";
             proxy_set_header Host ccc;
 }
             location = /ss-ws {
                      proxy_redirect off;
                      proxy_pass http://127.0.0.1:30300;
                      proxy_http_version 1.1;
             proxy_set_header X-Real-IP aaa;
             proxy_set_header X-Forwarded-For bbb;
             proxy_set_header Upgrade ddd;
             proxy_set_header Connection "upgrade";
             proxy_set_header Host ccc;
 }
             location ^~ /vless-grpc {
                      proxy_redirect off;
                      grpc_set_header X-Real-IP aaa;
                      grpc_set_header X-Forwarded-For bbb;
             grpc_set_header Host ccc;
             grpc_pass grpc://127.0.0.1:24456;
 }
             location ^~ /vmess-grpc {
                      proxy_redirect off;
                      grpc_set_header X-Real-IP aaa;
                      grpc_set_header X-Forwarded-For bbb;
             grpc_set_header Host ccc;
             grpc_pass grpc://127.0.0.1:31234;
 }
             location ^~ /trojan-grpc {
                      proxy_redirect off;
                      grpc_set_header X-Real-IP aaa;
                      grpc_set_header X-Forwarded-For bbb;
             grpc_set_header Host ccc;
             grpc_pass grpc://127.0.0.1:33456;
 }
             location ^~ /ss-grpc {
                      proxy_redirect off;
                      grpc_set_header X-Real-IP aaa;
                      grpc_set_header X-Forwarded-For bbb;
             grpc_set_header Host ccc;
             grpc_pass grpc://127.0.0.1:30310;
 }
             location  /fallback {
                      proxy_redirect off;
                      proxy_pass http://127.0.0.1:8880;
                      proxy_http_version 1.1;
              proxy_set_header Upgrade ddd;
              proxy_set_header Connection upgrade;
              proxy_set_header Host ccc;
              proxy_cache_bypass ddd;
  }
        } 
EOF

# // Move
sed -i 's/aaa/$remote_addr/g' /etc/nginx/conf.d/alone.conf
sed -i 's/bbb/$proxy_add_x_forwarded_for/g' /etc/nginx/conf.d/alone.conf
sed -i 's/ccc/$host/g' /etc/nginx/conf.d/alone.conf
sed -i 's/ddd/$http_upgrade/g' /etc/nginx/conf.d/alone.conf

# // Certv2ray
curl -s https://get.acme.sh | sh
/root/.acme.sh/acme.sh  --upgrade  --auto-upgrade
/root/.acme.sh/acme.sh --set-default-ca --server letsencrypt
/root/.acme.sh/acme.sh --issue -d ${domain} --standalone -k ec-256 --listen-v6 --force >> /etc/jinggovpn/tls/$domain.log
~/.acme.sh/acme.sh --installcert -d ${domain} --fullchainpath /etc/jinggovpn/tls/xray.crt --keypath /etc/jinggovpn/tls/xray.key --ecc
cat /etc/jinggovpn/tls/$domain.log

sleep 1
clear

# // Xray
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install --version 1.5.8


# // Restart & Add File
systemctl daemon-reload
systemctl stop xray
systemctl start xray
systemctl enable xray.service

# // Uuid Service
uuid=$(cat /proc/sys/kernel/random/uuid)

# // Json File
echo '
{
  "log" : {
    "access": "/var/log/xray/access.log",
    "error": "/var/log/xray/error.log",
    "loglevel": "warning"
  },
  "inbounds": [
      {
      "listen": "127.0.0.1",
      "port": 10085,
      "protocol": "dokodemo-door",
      "settings": {
        "address": "127.0.0.1"
      },
      "tag": "api"
    },
   {
     "listen": "127.0.0.1",
     "port": "14016",
     "protocol": "vless",
      "settings": {
          "decryption":"none",
            "clients": [
               {
                 "id": "$uuid"                 
#vless
             }
          ]
       },
       "streamSettings":{
         "network": "ws",
            "wsSettings": {
                "path": "/vless"
          }
        }
     },
     {
     "listen": "127.0.0.1",
     "port": "23456",
     "protocol": "vmess",
      "settings": {
            "clients": [
               {
                 "id": "$uuid",
                 "alterId": 0
#vmess
             }
          ]
       },
       "streamSettings":{
         "network": "ws",
            "wsSettings": {
                "path": "/vmess"
          }
        }
     },
    {
      "listen": "127.0.0.1",
      "port": "25432",
      "protocol": "trojan",
      "settings": {
          "decryption":"none",		
           "clients": [
              {
                 "password": "$uuid"
#trojanws
              }
          ],
         "udp": true
       },
       "streamSettings":{
           "network": "ws",
           "wsSettings": {
               "path": "/trojan-ws"
            }
         }
     },
    {
         "listen": "127.0.0.1",
        "port": "30300",
        "protocol": "shadowsocks",
        "settings": {
           "clients": [
           {
           "method": "aes-128-gcm",
          "password": "$uuid"
#ssws
           }
          ],
          "network": "tcp,udp"
       },
       "streamSettings":{
          "network": "ws",
             "wsSettings": {
               "path": "/ss-ws"
           }
        }
     },	
      {
        "listen": "127.0.0.1",
     "port": "24456",
        "protocol": "vless",
        "settings": {
         "decryption":"none",
           "clients": [
             {
               "id": "$uuid"
#vlessgrpc
             }
          ]            
       },
          "streamSettings":{
             "network": "grpc",
             "grpcSettings": {
                "serviceName": "vless-grpc"
           }
        }
     },
     {
      "listen": "127.0.0.1",
     "port": "31234",
     "protocol": "vmess",
      "settings": {
            "clients": [
               {
                 "id": "$uuid",
                 "alterId": 0
#vmessgrpc
             }
          ]
       },
       "streamSettings":{
         "network": "grpc",
            "grpcSettings": {
                "serviceName": "vmess-grpc"
          }
        }
     },
     {
        "listen": "127.0.0.1",
     "port": "33456",
        "protocol": "trojan",
        "settings": {
          "decryption":"none",
             "clients": [
               {
                 "password": "$uuid"
#trojangrpc
               }
           ]
        },
         "streamSettings":{
         "network": "grpc",
           "grpcSettings": {
               "serviceName": "trojan-grpc"
         }
      }
  },
   {
    "listen": "127.0.0.1",
    "port": "30310",
    "protocol": "shadowsocks",
    "settings": {
        "clients": [
          {
             "method": "aes-128-gcm",
             "password": "$uuid"
#ssgrpc
           }
         ],
           "network": "tcp,udp"
      },
    "streamSettings":{
     "network": "grpc",
        "grpcSettings": {
           "serviceName": "ss-grpc"
          }
       }
    }	
  ],
  "outbounds": [
    {
      "protocol": "freedom",
      "settings": {}
    },
    {
      "protocol": "blackhole",
      "settings": {},
      "tag": "blocked"
    }
  ],
  "routing": {
    "rules": [
      {
        "type": "field",
        "ip": [
          "0.0.0.0/8",
          "10.0.0.0/8",
          "100.64.0.0/10",
          "169.254.0.0/16",
          "172.16.0.0/12",
          "192.0.0.0/24",
          "192.0.2.0/24",
          "192.168.0.0/16",
          "198.18.0.0/15",
          "198.51.100.0/24",
          "203.0.113.0/24",
          "::1/128",
          "fc00::/7",
          "fe80::/10"
        ],
        "outboundTag": "blocked"
      },
      {
        "inboundTag": [
          "api"
        ],
        "outboundTag": "api",
        "type": "field"
      },
      {
        "type": "field",
        "outboundTag": "blocked",
        "protocol": [
          "bittorrent"
        ]
      }
    ]
  },
  "stats": {},
  "api": {
    "services": [
      "StatsService"
    ],
    "tag": "api"
  },
  "policy": {
    "levels": {
      "0": {
        "statsUserDownlink": true,
        "statsUserUplink": true
      }
    },
    "system": {
      "statsInboundUplink": true,
      "statsInboundDownlink": true,
      "statsOutboundUplink" : true,
      "statsOutboundDownlink" : true
    }
  }
}

' > /usr/local/etc/xray/config.json

sleep 1

# // Iptable xray
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 14016 -j ACCEPT
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 10085 -j ACCEPT
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 23456 -j ACCEPT
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 25432 -j ACCEPT
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 30300 -j ACCEPT
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 24456 -j ACCEPT
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 31234 -j ACCEPT
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 33456 -j ACCEPT
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 30310 -j ACCEPT

# // xray
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 14016 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 10085 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 23456 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 25432 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 30300 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 24456 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 31234 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 33456 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 30310 -j ACCEPT

iptables-save >/etc/iptables.rules.v4
netfilter-persistent save
netfilter-persistent reload

# // Starting
systemctl daemon-reload
systemctl restart xray
systemctl enable xray
systemctl restart xray.service
systemctl enable xray.service

# // Download
cd /usr/local/bin
wget -O trialxray "https://raw.githubusercontent.com/${GitUser}/${Repo}/main/${dir}/trialxray.sh"

wget -O addvless "https://raw.githubusercontent.com/${GitUser}/${Repo}/main/${dir}/addvless.sh"
wget -O cekvless "https://raw.githubusercontent.com/${GitUser}/${Repo}/main/${dir}/cekvless.sh"
wget -O delvless "https://raw.githubusercontent.com/${GitUser}/${Repo}/main/${dir}/delvless.sh"
wget -O renewvless "https://raw.githubusercontent.com/${GitUser}/${Repo}/main/${dir}/renewvless.sh"
wget -O trialvless "https://raw.githubusercontent.com/${GitUser}/${Repo}/main/${dir}/trialvless.sh"

wget -O addvmess "https://raw.githubusercontent.com/${GitUser}/${Repo}/main/${dir}/addvmess.sh"
wget -O cekvmess "https://raw.githubusercontent.com/${GitUser}/${Repo}/main/${dir}/cekvmess.sh"
wget -O delvmess "https://raw.githubusercontent.com/${GitUser}/${Repo}/main/${dir}/delvmess.sh"
wget -O renewvmess "https://raw.githubusercontent.com/${GitUser}/${Repo}/main/${dir}/renewvmess.sh"
wget -O trialvmess "https://raw.githubusercontent.com/${GitUser}/${Repo}/main/${dir}/trialvmess.sh"

wget -O addtrojan "https://raw.githubusercontent.com/${GitUser}/${Repo}/main/${dir}/addtrojan.sh"
wget -O cektrojan "https://raw.githubusercontent.com/${GitUser}/${Repo}/main/${dir}/cektrojan.sh"
wget -O deltrojan "https://raw.githubusercontent.com/${GitUser}/${Repo}/main/${dir}/deltrojan.sh"
wget -O renewtrojan "https://raw.githubusercontent.com/${GitUser}/${Repo}/main/${dir}/renewtrojan.sh"
wget -O trialtrojan "https://raw.githubusercontent.com/${GitUser}/${Repo}/main/${dir}/trialtrojan.sh"

# // Menu Xray
wget -O mxraynew "https://raw.githubusercontent.com/${GitUser}/${Repo}/main/${dir}/mxraynew.sh"
wget -O mxraytrial "https://raw.githubusercontent.com/${GitUser}/${Repo}/main/${dir}/mxraytrial.sh"
wget -O mxrayextend "https://raw.githubusercontent.com/${GitUser}/${Repo}/main/${dir}/mxrayextend.sh"
wget -O mxraycek "https://raw.githubusercontent.com/${GitUser}/${Repo}/main/${dir}/mxraycek.sh"
wget -O mxraydel "https://raw.githubusercontent.com/${GitUser}/${Repo}/main/${dir}/mxraydel.sh"

chmod +x trialxray
chmod +x addvless
chmod +x delvless
chmod +x cekvless
chmod +x renewvless
chmod +x trialvless
chmod +x addvmess
chmod +x delvmess
chmod +x cekvmess
chmod +x renewvmess
chmod +x trialvmess
chmod +x addtrojan
chmod +x deltrojan
chmod +x cektrojan
chmod +x renewtrojan
chmod +x trialtrojan
chmod +x mxraynew
chmod +x mxraytrial
chmod +x mxrayextend
chmod +x mxraycek
chmod +x mxraydel
cd


rm -f ins-xray.sh
clear
echo -e " ${RED}XRAY INSTALL DONE ${NC}"
sleep 2
clear

cp /root/domain /etc/xray
systemctl daemon-reload
systemctl restart nginx
systemctl restart xray