#!/bin/bash

# Definir colores
COL_BANNER1="\e[38;5;69m"   # #6F4BFO
COL_BANNER2="\e[38;5;117m"  # #CED4F5
COL_BANNER3="\e[38;5;33m"   # #006BFA
COL_BANNER4="\e[38;5;119m"  # #EAFFF8
COL_HEADER="\e[38;5;69m"    # #6F4BFO
COL_MENU="\e[38;5;69m"      # #6F4BFO
COL_TEXT="\e[38;5;69m"      # #6F4BFO
COL_ERROR="\e[38;5;196m"    # Rojo
COL_WHITE="\e[38;5;15m"     # Blanco
NC='\e[0m'                  # Sin color

# Función para mostrar los puertos activos
mostrar_puertos() {
    ./puertos.sh
}

# Función para mostrar el menú de conexiones
menu_conexiones() {
    clear
    echo -e "${COL_WHITE}====================================${NC}"
    echo -e "${COL_BANNER2}         PUERTOS ACTIVOS            ${NC}"
    echo -e "${COL_WHITE}====================================${NC}"
    mostrar_puertos
    echo
    echo -e "${COL_BANNER2}         MENU DE PROTOCOLOS          ${NC}"
    echo -e "${COL_HEADER}  [1] > DROPBEAR                     ${NC}"
    echo -e "${COL_HEADER}  [2] > SOCKS PYTHON                 ${NC}"
    echo -e "${COL_HEADER}  [3] > SSL                          ${NC}"
    echo -e "${COL_HEADER}  [4] > V2RAY                        ${NC}"
    echo -e "${COL_HEADER}  [5] > WEBSOCKET                    ${NC}"
    echo -e "${COL_HEADER}  [6] > BADVPN-UDP                   ${NC}"
    echo -e "${COL_HEADER}  [7] > SQUID                        ${NC}"
    echo -e "${COL_HEADER}  [8] > OPENVPN                      ${NC}"
    echo -e "${COL_HEADER}  [9] > SLOWDNS                      ${NC}"
    echo -e "${COL_HEADER}  [10] > WIREGUARD                   ${NC}"
    echo -e "${COL_HEADER}  [11] > PROTOCOLOS UDP              ${NC}"
    echo -e "${COL_HEADER}  [12] > PSIPHON                     ${NC}"
    echo -e "${COL_HEADER}  [13] > WS-EPRO                     ${NC}"
    echo -e "${COL_ERROR}  [0] > VOLVER                       ${NC}"
    echo -e "${COL_WHITE}====================================${NC}"
    echo -n "Seleccione una opción: "
    read opcion

    case $opcion in
        0) exit 0 ;;  # Salir del script
        1) chmod +x /root/FibersTV/conexiones/dropbear/dropbear.sh && /root/FibersTV/conexiones/dropbear/dropbear.sh ;;
        2) chmod +x /root/FibersTV/conexiones/socks_python/socks_python.sh && /root/FibersTV/conexiones/socks_python/socks_python.sh ;;
        3) chmod +x /root/FibersTV/conexiones/ssl/ssl.sh && /root/FibersTV/conexiones/ssl/ssl.sh ;;
        4) chmod +x /root/FibersTV/conexiones/v2ray/v2ray.sh && /root/FibersTV/conexiones/v2ray/v2ray.sh ;;
        5) chmod +x /root/FibersTV/conexiones/websocket/websocket.sh && /root/FibersTV/conexiones/websocket/websocket.sh ;;
        6) chmod +x /root/FibersTV/conexiones/badvpn_udp/badvpn_udp.sh && /root/FibersTV/conexiones/badvpn_udp/badvpn_udp.sh ;;
        7) chmod +x /root/FibersTV/conexiones/squid/squid.sh && /root/FibersTV/conexiones/squid/squid.sh ;;
        8) chmod +x /root/FibersTV/conexiones/openvpn/openvpn.sh && /root/FibersTV/conexiones/openvpn/openvpn.sh ;;
        9) chmod +x /root/FibersTV/conexiones/slowdns/slowdns.sh && /root/FibersTV/conexiones/slowdns/slowdns.sh ;;
        10) chmod +x /root/FibersTV/conexiones/wireguard/wireguard.sh && /root/FibersTV/conexiones/wireguard/wireguard.sh ;;
        11) chmod +x /root/FibersTV/conexiones/udp/udp.sh && /root/FibersTV/conexiones/udp/udp.sh ;;
        12) chmod +x /root/FibersTV/conexiones/psiphon/psiphon.sh && /root/FibersTV/conexiones/psiphon/psiphon.sh ;;
        13) chmod +x /root/FibersTV/conexiones/ws_epro/ws_epro.sh && /root/FibersTV/conexiones/ws_epro/ws_epro.sh ;;
        *) echo -e "${COL_ERROR}Opción inválida${NC}"; sleep 2 ;;
    esac

    # Volver al menú principal después de ejecutar la opción
    menu_conexiones
}

# Llamar al menú de conexiones
menu_conexiones
