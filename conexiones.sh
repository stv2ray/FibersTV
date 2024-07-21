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
    while true; do
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
        echo -e "${COL_HEADER}  [0] > VOLVER                       ${NC}"
        echo -e "${COL_WHITE}====================================${NC}"
        echo -n "Seleccione una opción: "
        read opcion

        case $opcion in
            0) break ;;  # Salir del bucle para volver al menú principal
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
            *) echo -e "${COL_ERROR}Opción inválida${NC}"; sleep 2 ;;
        esac
    done
}

# Llamar al menú de conexiones
menu_conexiones