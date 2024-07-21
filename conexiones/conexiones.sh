#!/bin/bash

# Definición de colores
HEADER_COLOR='\e[38;5;105m'  # #6F4BFO
OPTION_COLOR='\e[38;5;39m'   # #006BFA
NC='\e[0m'                   # Sin color
BOX_COLOR='\e[48;5;250m'     # Fondo de caja
BOX_TEXT_COLOR='\e[38;5;0m'  # Texto dentro de la caja

# Función para mostrar los puertos activos
mostrar_puertos() {
    /root/FibersTV/conexiones/puertos.sh
}

# Función para mostrar el menú de conexiones
menu_conexiones() {
    while true; do
        clear
        echo -e "${HEADER_COLOR}══════════════════════════════════════════════════════════════════════════════════${NC}"
        echo -e "${HEADER_COLOR}                            PUERTOS ACTIVOS${NC}"
        echo -e "${HEADER_COLOR}══════════════════════════════════════════════════════════════════════════════════${NC}"
        mostrar_puertos
        echo
        echo -e "${BOX_COLOR}${BOX_TEXT_COLOR}                      MENU DE PROTOCOLOS                      ${NC}"
        echo -e "${BOX_COLOR}${BOX_TEXT_COLOR}  [1] > DROPBEAR                              ${NC}"
        echo -e "${BOX_COLOR}${BOX_TEXT_COLOR}  [2] > SOCKS PYTHON                          ${NC}"
        echo -e "${BOX_COLOR}${BOX_TEXT_COLOR}  [3] > SSL                                  ${NC}"
        echo -e "${BOX_COLOR}${BOX_TEXT_COLOR}  [4] > V2RAY                                ${NC}"
        echo -e "${BOX_COLOR}${BOX_TEXT_COLOR}  [5] > WEBSOCKET                            ${NC}"
        echo -e "${BOX_COLOR}${BOX_TEXT_COLOR}  [6] > BADVPN-UDP                           ${NC}"
        echo -e "${BOX_COLOR}${BOX_TEXT_COLOR}  [7] > SQUID                                ${NC}"
        echo -e "${BOX_COLOR}${BOX_TEXT_COLOR}  [8] > OPENVPN                              ${NC}"
        echo -e "${BOX_COLOR}${BOX_TEXT_COLOR}  [9] > SLOWDNS                              ${NC}"
        echo -e "${BOX_COLOR}${BOX_TEXT_COLOR}  [10] > WIREGUARD                           ${NC}"
        echo -e "${BOX_COLOR}${BOX_TEXT_COLOR}  [11] > PROTOCOLOS UDP                      ${NC}"
        echo -e "${BOX_COLOR}${BOX_TEXT_COLOR}  [12] > PSIPHON                             ${NC}"
        echo -e "${BOX_COLOR}${BOX_TEXT_COLOR}  [13] > WS-EPRO                             ${NC}"
        echo
        echo -e "${HEADER_COLOR}══════════════════════════════════════════════════════════════════════════════════${NC}"
        echo -e "${OPTION_COLOR}[0] > VOLVER${NC}"
        echo -n "Seleccione una opción: "
        read opcion

        case $opcion in
            0) menu_principal ;;  # Asegúrate de tener esta función definida en tu menú principal
            1) /root/FibersTV/conexiones/dropbear/dropbear.sh ;;
            2) /root/FibersTV/conexiones/socks_python/socks_python.sh ;;
            3) /root/FibersTV/conexiones/ssl/ssl.sh ;;
            4) /root/FibersTV/conexiones/v2ray/v2ray.sh ;;
            5) /root/FibersTV/conexiones/websocket/websocket.sh ;;
            6) /root/FibersTV/conexiones/badvpn_udp/badvpn_udp.sh ;;
            7) /root/FibersTV/conexiones/squid/squid.sh ;;
            8) /root/FibersTV/conexiones/openvpn/openvpn.sh ;;
            9) /root/FibersTV/conexiones/slowdns/slowdns.sh ;;
            10) /root/FibersTV/conexiones/wireguard/wireguard.sh ;;
            11) /root/FibersTV/conexiones/udp/udp.sh ;;
            12) /root/FibersTV/conexiones/psiphon/psiphon.sh ;;
            13) /root/FibersTV/conexiones/ws_epro/ws_epro.sh ;;
            *) echo -e "${RED}Opción inválida${NC}"; sleep 2 ;;
        esac
    done
}

# Llamar al menú de conexiones
menu_conexione
