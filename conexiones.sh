#!/bin/bash

# Incluir el script principal para acceder a la función menu_principal
source ./FibersTV.sh

# Definición de colores
HEADER_COLOR='\e[38;5;69m'  # #6F4BFO
OPTION_COLOR='\e[38;5;69m'  # #6F4BFO
NC='\e[0m'                  # Sin color

# Función para mostrar los puertos activos
mostrar_puertos() {
    ./puertos.sh
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
        echo -e "${HEADER_COLOR}                      MENU DE PROTOCOLOS                      ${NC}"
        echo -e "${HEADER_COLOR}  [1] > DROPBEAR                              ${NC}"
        echo -e "${HEADER_COLOR}  [2] > SOCKS PYTHON                          ${NC}"
        echo -e "${HEADER_COLOR}  [3] > SSL                                  ${NC}"
        echo -e "${HEADER_COLOR}  [4] > V2RAY                                ${NC}"
        echo -e "${HEADER_COLOR}  [5] > WEBSOCKET                            ${NC}"
        echo -e "${HEADER_COLOR}  [6] > BADVPN-UDP                           ${NC}"
        echo -e "${HEADER_COLOR}  [7] > SQUID                                ${NC}"
        echo -e "${HEADER_COLOR}  [8] > OPENVPN                              ${NC}"
        echo -e "${HEADER_COLOR}  [9] > SLOWDNS                              ${NC}"
        echo -e "${HEADER_COLOR}  [10] > WIREGUARD                           ${NC}"
        echo -e "${HEADER_COLOR}  [11] > PROTOCOLOS UDP                      ${NC}"
        echo -e "${HEADER_COLOR}  [12] > PSIPHON                             ${NC}"
        echo -e "${HEADER_COLOR}  [13] > WS-EPRO                             ${NC}"
        echo
        echo -e "${HEADER_COLOR}══════════════════════════════════════════════════════════════════════════════════${NC}"
        echo -e "${OPTION_COLOR}[0] > VOLVER${NC}"
        echo -n "Seleccione una opción: "
        read opcion

        case $opcion in
            0) menu_principal ;;  # Asegúrate de tener esta función definida en tu menú principal
            1) ./dropbear.sh ;;
            2) ./socks_python.sh ;;
            3) ./ssl.sh ;;
            4) ./v2ray.sh ;;
            5) ./websocket.sh ;;
            6) ./badvpn_udp.sh ;;
            7) ./squid.sh ;;
            8) ./openvpn.sh ;;
            9) ./slowdns.sh ;;
            10) ./wireguard.sh ;;
            11) ./udp.sh ;;
            12) ./psiphon.sh ;;
            13) ./ws_epro.sh ;;
            *) echo -e "${RED}Opción inválida${NC}"; sleep 2 ;;
        esac
    done
}

# Llamar al menú de conexiones
menu_conexiones