#!/bin/bash

# Definir colores
COL_BANNER1="\e[38;5;69m"   # #6F4BFO
COL_BANNER2="\e[38;5;123m"  # #CED4F5
COL_BANNER3="\e[38;5;33m"   # #006BFA
COL_BANNER4="\e[38;5;119m"  # #EAFFF8
COL_HEADER="\e[38;5;69m"    # #6F4BFO
COL_MENU="\e[38;5;69m"      # #6F4BFO
COL_TEXT="\e[38;5;69m"      # #6F4BFO
COL_ERROR="\e[38;5;196m"    # Rojo
NC='\e[0m'                  # Sin color

# Función para mostrar el banner con degradado
mostrar_banner() {
    clear
    echo -e "********************************"
    echo -e "${COL_BANNER3}*        ${NC}${COL_BANNER2}FIBERSTV.COM${NC}${COL_BANNER3}         *${NC}"
    echo -e "********************************"
    echo -e "${COL_BANNER1}********************************${NC}"
}

# Función para mostrar la información del sistema
mostrar_info_sistema() {
    echo -e "Memoria RAM: ${COL_TEXT}$(free -h | grep Mem | awk '{print $3 "/" $2}')${NC}"
    echo -e "CPU: ${COL_TEXT}$(lscpu | grep 'Model name' | awk -F: '{print $2}' | xargs)${NC}"
    echo -e "Fecha y Hora: ${COL_TEXT}$(date)${NC}"
}

# Función para mostrar el menú principal
menu_principal() {
    mostrar_banner
    mostrar_info_sistema
    echo -e "PANEL DE CONTROL"
    echo -e "${COL_MENU}1) CUENTAS${NC}"
    echo -e "${COL_MENU}2) CONEXIONES${NC}"
    echo -e "${COL_MENU}3) HERRAMIENTAS${NC}"
    echo -e "${COL_MENU}4) BACKUP${NC}"
    echo -e "${COL_MENU}5) ACTUALIZAR${NC}"
    echo -e "${COL_MENU}6) DESINSTALAR${NC}"
    echo -e "${COL_MENU}0) SALIR DEL SCRIPT${NC}"
    echo -n "Seleccione una opción: "
    read opcion

    case $opcion in
        1) ./cuentas.sh ;;
        2) ./conexiones.sh ;;
        3) ./herramientas.sh ;;
        4) ./backup.sh ;;
        5) ./actualizar.sh ;;
        6) ./desinstalar.sh ;;
        0) exit ;;
        *) echo -e "${COL_ERROR}Opción inválida${NC}"; sleep 2 ;;
    esac
}

# Bucle para mantener el menú principal activo
while true; do
    menu_principal
done