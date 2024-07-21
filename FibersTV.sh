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
    echo -e "\e[48;5;39m\e[97m*             \e[48;5;39m\e[97m   FIBERSTV.COM   \e[0m\e[48;5;39m\e[97m*\e[0m"
    echo -e "\e[48;5;39m\e[97m**********************************************\e[0m"
}

# Función para mostrar la información del sistema
mostrar_info_sistema() {
    echo -e "\e[48;5;40m\e[97mMemoria RAM: $(free -h | grep Mem | awk '{print $3 "/" $2}')\e[0m"
    echo -e "\e[48;5;40m\e[97mCPU: $(lscpu | grep 'Model name' | awk -F: '{print $2}' | xargs)\e[0m"
    echo -e "\e[48;5;40m\e[97mFecha y Hora: $(date)\e[0m"
}

# Función para mostrar el menú principal
menu_principal() {
    mostrar_banner
    mostrar_info_sistema
    echo -e "\e[48;5;28m\e[97mPANEL DE CONTROL\e[0m"
    echo -e "\e[48;5;28m\e[97m1) \e[48;5;33m\e[97mUSUARIOS \e[0m"
    echo -e "\e[48;5;28m\e[97m2) \e[48;5;33m\e[97mCONEXIONES \e[0m"
    echo -e "\e[48;5;28m\e[97m3) \e[48;5;33m\e[97mHERRAMIENTAS \e[0m"
    echo -e "\e[48;5;28m\e[97m4) \e[48;5;33m\e[97mBACKUP \e[0m"
    echo -e "\e[48;5;28m\e[97m5) \e[48;5;33m\e[97mACTUALIZAR \e[0m"
    echo -e "\e[48;5;28m\e[97m6) \e[48;5;33m\e[97mDESINSTALAR \e[0m"
    echo -e "\e[48;5;28m\e[97m0) \e[48;5;33m\e[97mSALIR DEL SCRIPT \e[0m"
    echo -n "Seleccione una opción: "
    read opcion

    case $opcion in
        1) menu_usuarios ;;
        2) menu_conexiones ;;
        3) menu_herramientas ;;
        4) menu_backup ;;
        5) actualizar ;;
        6) desinstalar ;;
        0) exit ;;
        *) echo -e "\e[48;5;9m\e[97mOpción inválida\e[0m"; sleep 2; menu_principal ;;
    esac
}

# Función para el menú de usuarios (ejemplo de implementación)
menu_usuarios() {
    clear
    echo -e "\e[48;5;33m\e[97mMenu Usuarios\e[0m"
    # Agregar opciones y lógica para el menú de usuarios
    echo -e "\e[48;5;33m\e[97m0) Volver al menú principal\e[0m"
    echo -n "Seleccione una opción: "
    read opcion
    case $opcion in
        0) menu_principal ;;
        *) echo -e "\e[48;5;9m\e[97mOpción inválida\e[0m"; sleep 2; menu_usuarios ;;
    esac
}

# Llamar al menú principal al iniciar el script
menu_principal