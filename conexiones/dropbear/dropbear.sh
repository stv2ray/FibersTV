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
NC='\e[0m'                  # Sin color

# Función para mostrar el menú de Dropbear
menu_dropbear() {
    while true; do
        clear
        echo -e "${COL_HEADER}====================================${NC}"
        echo -e "${COL_BANNER2}              DROPBEAR              ${NC}"
        echo -e "${COL_HEADER}====================================${NC}"
        echo -e "${COL_MENU}[1] > INSTALAR DROPBEAR${NC}"
        echo -e "${COL_MENU}[2] > REDEFINIR PUERTOS${NC}"
        echo -e "${COL_MENU}[3] > CONFIGURACIÓN MANUAL (nano)${NC}"
        echo -e "${COL_MENU}[4] > ESTADO DEL SERVICIO${NC}"
        echo -e "${COL_MENU}[5] > REINICIAR SERVICIO${NC}"
        echo -e "${COL_MENU}[6] > INICIAR/DETENER SERVICIO [ON/OFF]${NC}"
        echo -e "${COL_MENU}[7] > DESINSTALAR DROPBEAR${NC}"
        echo -e "${COL_ERROR}[0] > VOLVER${NC}"
        echo -e "${COL_HEADER}====================================${NC}"
        echo -n "Seleccione una opción: "
        read opcion

        case $opcion in
            1) instalar_dropbear ;;
            2) redefinir_puertos_dropbear ;;
            3) sudo nano /etc/default/dropbear; menu_dropbear ;;
            4) estado_servicio_dropbear ;;
            5) reiniciar_dropbear ;;
            6) iniciar_detener_dropbear ;;
            7) desinstalar_dropbear ;;
            0) break ;;  # Volver al menú de conexiones
            *) echo -e "${COL_ERROR}Opción inválida${NC}"; sleep 2 ;;
        esac
    done
}

# Función para instalar Dropbear
instalar_dropbear() {
    sudo apt-get update
    sudo apt-get install -y dropbear
    sudo sed -i "s/NO_START=1/NO_START=0/" /etc/default/dropbear
    sudo systemctl enable dropbear
    sudo systemctl start dropbear
    echo -e "${COL_TEXT}Dropbear instalado y configurado.${NC}"
    sudo ufw allow 22/tcp
    sleep 2
    menu_dropbear
}

# Función para redefinir puertos de Dropbear
redefinir_puertos_dropbear() {
    echo -n "Ingrese el puerto para Dropbear: "
    read puerto
    sudo sed -i "s/DROPBEAR_PORT=.*/DROPBEAR_PORT=$puerto/" /etc/default/dropbear
    sudo systemctl restart dropbear
    sudo ufw allow $puerto/tcp
    echo -e "${COL_TEXT}Dropbear configurado para escuchar en el puerto $puerto.${NC}"
    sleep 2
    menu_dropbear
}

# Función para mostrar el estado del servicio Dropbear
estado_servicio_dropbear() {
    sudo systemctl status dropbear
    echo "Presione cualquier tecla para volver."
    read -n 1
    menu_dropbear
}

# Función para reiniciar Dropbear
reiniciar_dropbear() {
    sudo systemctl restart dropbear
    echo -e "${COL_TEXT}Dropbear reiniciado.${NC}"
    sleep 2
    menu_dropbear
}

# Función para iniciar o detener el servicio Dropbear
iniciar_detener_dropbear() {
    estado=$(sudo systemctl is-active dropbear)
    if [ "$estado" == "active" ]; then
        sudo systemctl stop dropbear
        echo -e "${COL_ERROR}Dropbear detenido.${NC}"
    else
        sudo systemctl start dropbear
        echo -e "${COL_TEXT}Dropbear iniciado.${NC}"
    fi
    sleep 2
    menu_dropbear
}

# Función para desinstalar Dropbear
desinstalar_dropbear() {
    sudo apt-get remove --purge -y dropbear
    sudo rm -f /etc/default/dropbear
    sudo ufw delete allow 22/tcp
    echo -e "${COL_TEXT}Dropbear desinstalado.${NC}"
    sleep 2
    menu_dropbear
}

# Llamar al menú de Dropbear
menu_dropbear
