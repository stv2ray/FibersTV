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
    echo -n "Ingrese el puerto para Dropbear: "
    read puerto_escucha
    echo -n "Ingrese el puerto de redirección (por ejemplo, 22 para OpenSSH): "
    read puerto_redireccion
    sudo apt-get update
    sudo apt-get install -y dropbear
    sudo sed -i "s/NO_START=1/NO_START=0/" /etc/default/dropbear
    sudo sed -i "s/DROPBEAR_PORT=.*/DROPBEAR_PORT=$puerto_escucha/" /etc/default/dropbear
    sudo sed -i "s|DROPBEAR_EXTRA_ARGS=.*|DROPBEAR_EXTRA_ARGS=\"\"|" /etc/default/dropbear
    # Generar claves SSH si no existen
    if [ ! -f /etc/dropbear/dropbear_rsa_host_key ]; then
        sudo dropbearkey -t rsa -f /etc/dropbear/dropbear_rsa_host_key
        sudo chmod 600 /etc/dropbear/dropbear_rsa_host_key
    fi
    if [ ! -f /etc/dropbear/dropbear_dss_host_key ]; then
        sudo dropbearkey -t dss -f /etc/dropbear/dropbear_dss_host_key
        sudo chmod 600 /etc/dropbear/dropbear_dss_host_key
    fi
    if [ ! -f /etc/dropbear/dropbear_ecdsa_host_key ]; then
        sudo dropbearkey -t ecdsa -f /etc/dropbear/dropbear_ecdsa_host_key
        sudo chmod 600 /etc/dropbear/dropbear_ecdsa_host_key
    fi
    sudo systemctl enable dropbear
    sudo systemctl start dropbear
    sudo ufw allow $puerto_escucha/tcp
    sudo ufw allow $puerto_redireccion/tcp
    echo -e "${COL_TEXT}Dropbear instalado y configurado para escuchar en el puerto $puerto_escucha y redirigir al puerto $puerto_redireccion.${NC}"
    sudo systemctl restart dropbear
    sleep 2
    menu_dropbear
}

# Función para redefinir puertos de Dropbear
redefinir_puertos_dropbear() {
    echo -n "Ingrese el puerto para Dropbear: "
    read puerto_escucha
    echo -n "Ingrese el puerto de redirección (por ejemplo, 22 para OpenSSH): "
    read puerto_redireccion
    sudo sed -i "s/DROPBEAR_PORT=.*/DROPBEAR_PORT=$puerto_escucha/" /etc/default/dropbear
    sudo sed -i "s|DROPBEAR_EXTRA_ARGS=.*|DROPBEAR_EXTRA_ARGS=\"\"|" /etc/default/dropbear
    sudo systemctl restart dropbear
    sudo ufw allow $puerto_escucha/tcp
    sudo ufw allow $puerto_redireccion/tcp
    echo -e "${COL_TEXT}Dropbear configurado para escuchar en el puerto $puerto_escucha y redirigir al puerto $puerto_redireccion.${NC}"
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