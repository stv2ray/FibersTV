#!/bin/bash

# Definir colores
COL_BANNER="#67CAD2"
COL_HEADER="#00BE92"
COL_MENU="#3CF490"
COL_TEXT="#FFFFFF"
COL_ERROR="#FF6347"

# Función para mostrar el banner
mostrar_banner() {
    clear
    echo -e "\e[48;5;39m\e[97m**********************************************\e[0m"
    echo -e "\e[48;5;39m\e[97m*             \e[38;5;82mFIBERSTV.COM\e[0m\e[48;5;39m\e[97m*\e[0m"
    echo -e "\e[48;5;39m\e[97m**********************************************\e[0m"
}

# Función para mostrar la información del sistema
mostrar_info_sistema() {
    echo -e "Memoria RAM: \e[38;5;82m$(free -h | grep Mem | awk '{print $3 "/" $2}')\e[0m"
    echo -e "CPU: \e[38;5;82m$(lscpu | grep 'Model name' | awk -F: '{print $2}' | xargs)\e[0m"
    echo -e "Fecha y Hora: \e[38;5;82m$(date)\e[0m"
}

# Función para mostrar el menú principal
menu_principal() {
    mostrar_banner
    mostrar_info_sistema
    echo -e "\e[38;5;39mPANEL DE CONTROL\e[0m"
    echo -e "1) \e[38;5;33mCUENTAS\e[0m"
    echo -e "2) \e[38;5;33mCONEXIONES\e[0m"
    echo -e "3) \e[38;5;33mHERRAMIENTAS\e[0m"
    echo -e "4) \e[38;5;33mBACKUP\e[0m"
    echo -e "5) \e[38;5;33mACTUALIZAR\e[0m"
    echo -e "6) \e[38;5;33mDESINSTALAR\e[0m"
    echo -e "0) \e[38;5;33mSALIR DEL SCRIPT\e[0m"
    echo -n "Seleccione una opción: "
    read opcion

    case $opcion in
        1) ./usuarios/cuentas.sh ;;
        2) ./conexiones/conexiones.sh ;;
        3) ./herramientas/herramientas.sh ;;
        4) ./backup/backup.sh ;;
        5) ./actualizar/actualizar.sh ;;
        6) ./desinstalar/desinstalar.sh ;;
        0) exit ;;
        *) echo -e "\e[38;5;9mOpción inválida\e[0m"; sleep 2 ;;
    esac
}

# Mostrar el menú principale
menu_principal
