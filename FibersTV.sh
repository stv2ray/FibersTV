#!/bin/bash

# Definir colores
COL_BANNER1="\e[38;5;231m"  # Blanco
COL_BANNER2="\e[38;5;225m"  # Rosa claro
COL_BANNER3="\e[38;5;219m"  # Rosa
COL_BANNER4="\e[38;5;213m"  # Rosa oscuro
COL_BANNER5="\e[38;5;207m"  # Magenta claro
COL_HEADER="\e[38;5;82m"    # Verde claro
COL_MENU="\e[38;5;82m"      # Verde claro
COL_TEXT="\e[38;5;82m"      # Verde claro
COL_ERROR="\e[38;5;196m"    # Rojo
NC='\e[0m'                  # Sin color

# Función para mostrar el banner con degradado
mostrar_banner() {
    clear
    echo -e "${COL_BANNER1}********************************${NC}"
    echo -e "${COL_BANNER2}*        ${COL_BANNER1}FIBERSTV.COM${COL_BANNER2}         *${NC}"
    echo -e "${COL_BANNER3}********************************${NC}"
    echo -e "${COL_BANNER4}********************************${NC}"
    echo -e "${COL_BANNER5}********************************${NC}"
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
    echo -e "${COL_HEADER}PANEL DE CONTROL${NC}"
    echo -e "1) ${COL_MENU}CUENTAS${NC}"
    echo -e "2) ${COL_MENU}CONEXIONES${NC}"
    echo -e "3) ${COL_MENU}HERRAMIENTAS${NC}"
    echo -e "4) ${COL_MENU}BACKUP${NC}"
    echo -e "5) ${COL_MENU}ACTUALIZAR${NC}"
    echo -e "6) ${COL_MENU}DESINSTALAR${NC}"
    echo -e "0) ${COL_MENU}SALIR DEL SCRIPT${NC}"
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
