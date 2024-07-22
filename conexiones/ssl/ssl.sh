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

# Función para mostrar el menú de SSL (Stunnel4)
menu_ssl() {
    clear
    echo -e "${COL_HEADER}====================================${NC}"
    echo -e "${COL_BANNER2}              SSL (STUNNEL4)        ${NC}"
    echo -e "${COL_HEADER}====================================${NC}"
    echo -e "${COL_MENU}[1] > INSTALAR STUNNEL4${NC}"
    echo -e "${COL_MENU}[2] > REDEFINIR PUERTOS${NC}"
    echo -e "${COL_MENU}[3] > CONFIGURACIÓN MANUAL (nano)${NC}"
    echo -e "${COL_MENU}[4] > ESTADO DEL SERVICIO${NC}"
    echo -e "${COL_MENU}[5] > REINICIAR SERVICIO${NC}"
    echo -e "${COL_MENU}[6] > INICIAR/DETENER SERVICIO [ON/OFF]${NC}"
    echo -e "${COL_MENU}[7] > DESINSTALAR STUNNEL4${NC}"
    echo -e "${COL_ERROR}[0] > VOLVER${NC}"
    echo -e "${COL_HEADER}====================================${NC}"
    echo -n "Seleccione una opción: "
    read opcion

    case $opcion in
        1) instalar_stunnel ;;
        2) redefinir_puertos_stunnel ;;
        3) sudo nano /etc/stunnel/stunnel.conf; menu_ssl ;;
        4) estado_servicio_stunnel ;;
        5) reiniciar_stunnel ;;
        6) iniciar_detener_stunnel ;;
        7) desinstalar_stunnel ;;
        0) menu_conexion ;;
        *) echo -e "${COL_ERROR}Opción inválida${NC}"; sleep 2; menu_ssl ;;
    esac
}

# Función para instalar Stunnel4
instalar_stunnel() {
    echo -n "Ingrese el puerto para Stunnel4: "
    read puerto_escucha
    echo -n "Ingrese el puerto de redirección (por ejemplo, 22 para OpenSSH): "
    read puerto_redireccion
    sudo apt-get update
    sudo apt-get install -y stunnel4
    sudo sed -i "s/ENABLED=0/ENABLED=1/" /etc/default/stunnel4
    # Crear certificado auto-firmado
    sudo mkdir -p /etc/stunnel
    sudo openssl req -new -x509 -days 365 -nodes -out /etc/stunnel/stunnel.pem -keyout /etc/stunnel/stunnel.pem << EOF
US
State
City
Organization
Unit
localhost.localdomain
admin@localhost.localdomain
EOF
    echo "client = no
cert = /etc/stunnel/stunnel.pem
[ssh]
accept = $puerto_escucha
connect = $puerto_redireccion" | sudo tee /etc/stunnel/stunnel.conf
    sudo systemctl enable stunnel4
    sudo systemctl start stunnel4
    sudo ufw allow $puerto_escucha/tcp
    echo -e "${COL_TEXT}Stunnel4 instalado y configurado en el puerto $puerto_escucha redirigiendo al puerto $puerto_redireccion.${NC}"
    sleep 2
    menu_ssl
}

# Función para redefinir puertos de Stunnel4
redefinir_puertos_stunnel() {
    clear
    echo -e "${COL_HEADER}====================================${NC}"
    echo -e "${COL_BANNER2}       Puertos actuales de Stunnel4 ${NC}"
    echo -e "${COL_HEADER}====================================${NC}"
    sudo netstat -tuln | grep stunnel
    echo -e "${COL_MENU}[1] > AGREGAR PUERTO STUNNEL4${NC}"
    echo -e "${COL_MENU}[2] > ELIMINAR PUERTO STUNNEL4${NC}"
    echo -e "${COL_ERROR}[0] > VOLVER${NC}"
    echo -n "Seleccione una opción: "
    read opcion

    case $opcion in
        1) agregar_puerto_stunnel ;;
        2) eliminar_puerto_stunnel ;;
        0) menu_ssl ;;
        *) echo -e "${COL_ERROR}Opción inválida${NC}"; sleep 2; redefinir_puertos_stunnel ;;
    esac
}

# Función para agregar puerto de Stunnel4
agregar_puerto_stunnel() {
    echo -n "Ingrese el puerto a agregar: "
    read puerto
    echo "client = no
[ssh]
accept = $puerto
connect = 22" | sudo tee -a /etc/stunnel/stunnel.conf
    sudo systemctl restart stunnel4
    sudo ufw allow $puerto/tcp
    echo -e "${COL_TEXT}Puerto $puerto agregado a Stunnel4.${NC}"
    sleep 2
    redefinir_puertos_stunnel
}

# Función para eliminar puerto de Stunnel4
eliminar_puerto_stunnel() {
    echo -n "Ingrese el puerto a eliminar: "
    read puerto
    sudo sed -i "/accept = $puerto/d" /etc/stunnel/stunnel.conf
    sudo systemctl restart stunnel4
    sudo ufw delete allow $puerto/tcp
    echo -e "${COL_TEXT}Puerto $puerto eliminado de Stunnel4.${NC}"
    sleep 2
    redefinir_puertos_stunnel
}

# Función para mostrar el estado del servicio Stunnel4
estado_servicio_stunnel() {
    sudo systemctl status stunnel4
    echo "Presione cualquier tecla para volver."
    read -n 1
    menu_ssl
}

# Función para reiniciar Stunnel4
reiniciar_stunnel() {
    sudo systemctl restart stunnel4
    echo -e "${COL_TEXT}Stunnel4 reiniciado.${NC}"
    sleep 2
    menu_ssl
}

# Función para iniciar o detener el servicio Stunnel4
iniciar_detener_stunnel() {
    estado=$(sudo systemctl is-active stunnel4)
    if [ "$estado" == "active" ]; then
        sudo systemctl stop stunnel4
        echo -e "${COL_ERROR}Stunnel4 detenido.${NC}"
    else
        sudo systemctl start stunnel4
        echo -e "${COL_TEXT}Stunnel4 iniciado.${NC}"
    fi
    sleep 2
    menu_ssl
}

# Función para desinstalar Stunnel4
desinstalar_stunnel() {
    sudo apt-get remove --purge -y stunnel4
    sudo rm -f /etc/stunnel/stunnel.conf
    sudo rm -f /etc/stunnel/stunnel.pem
    sudo ufw delete allow 443/tcp
    echo -e "${COL_TEXT}Stunnel4 desinstalado.${NC}"
    sleep 2
    menu_ssl
}

# Función para mostrar el menú de conexión (placeholder)
menu_conexion() {
    echo "Volviendo al menú de conexión..."
    # Aquí puedes agregar el código para el menú de conexión
}

# Iniciar el menú SSL
menu_ssl