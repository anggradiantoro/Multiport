#!/bin/bash
clear
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
echo -e ""
echo -e "  ═══════════════════════════════════════════════" 
echo -e "            ${green}TROJAN GFW${NC}                    " 
echo -e "  ═══════════════════════════════════════════════" 
echo -e "  " 
echo -e "   [ 1 ] CREATE NEW USER"
echo -e "   [ 2 ] DELETE ACTIVE USER"
echo -e "   [ 3 ] EXTEND ACTIVE USER"
echo -e "   [ 4 ] CHECK USER LOGIN"
echo -e "  " 
echo -e "  ═══════════════════════════════════════════════" 
echo -e "   ${green}[ 0 ] EXIT TO MENU${NC} "
echo -e "  ═══════════════════════════════════════════════" 
echo -e "\e[1;31m"
read -p "     Please select an option :  "  mtrojan
echo -e "\e[0m"
case $mtrojan in
      1)
      addtrojan
      ;;
      2)
      deltrojan
      ;;
      3)
      renewtrojan
      ;;
      4)
      cektrojan
      ;;
      0)
      menu
      ;;
      *)
      echo -e "Please enter an correct number"
      sleep 1
      clear
      mtrojan
      ;;
  esac
