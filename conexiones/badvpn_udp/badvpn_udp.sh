#!/bin/bash

# Paletas de colores
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

# Función para mostrar el banner
mostrar_banner() {
    echo -e "${COL_BANNER1}==============================${NC}"
    echo -e "${COL_BANNER2}     BADVPN-UDP INSTALLER     ${NC}"
    echo -e "${COL_BANNER3}==============================${NC}"
}

# Función para mostrar el menú de BadVPN
menu_badvpn_udp() {
    clear
    mostrar_banner
    echo -e "${COL_MENU}[1] > INSTALAR BADVPN-UDP${NC}"
    echo -e "${COL_MENU}[2] > REDEFINIR PUERTOS${NC}"
    echo -e "${COL_MENU}[3] > DESINSTALAR BADVPN-UDP${NC}"
    echo -e "${COL_ERROR}[0] > VOLVER${NC}"
    echo -n "Seleccione una opción: "
    read opcion

    case $opcion in
        1) instalar_badvpn ;;
        2) redefinir_puertos_badvpn ;;
        3) desinstalar_badvpn ;;
        0) menu_conexion ;;
        *) echo -e "${COL_ERROR}Opción inválida${NC}"; sleep 2; menu_badvpn_udp ;;
    esac
}

# Función para instalar BadVPN-UDP
instalar_badvpn() {
    echo -n "Ingrese el puerto para BadVPN-UDP: "
    read puerto_escucha

    # Actualizar el sistema
    sudo apt update && sudo apt upgrade -y

    # Instalar las dependencias necesarias
    sudo apt install -y build-essential cmake git

    # Clonar el repositorio de BadVPN
    git clone https://github.com/ambrop72/badvpn.git

    # Crear un directorio de compilación
    cd badvpn
    mkdir build
    cd build

    # Configurar el proyecto con CMake
    cmake .. -DBUILD_NOTHING_BY_DEFAULT=1 -DBUILD_UDPGW=1

    # Compilar el proyecto
    make

    # Instalar BadVPN
    sudo make install

    # Verificar la instalación
    badvpn-udpgw --help

    # Configurar el servicio de BadVPN
    sudo bash -c 'cat <<EOF > /etc/systemd/system/badvpn.service
[Unit]
Description=BadVPN UDP Gateway
After=network.target

[Service]
ExecStart=/usr/local/bin/badvpn-udpgw --listen-addr 0.0.0.0:$puerto_escucha
User=nobody
Group=nogroup
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF'

    # Habilitar y arrancar el servicio
    sudo systemctl enable badvpn
    sudo systemctl start badvpn

    # Verificar que el servicio está corriendo
    sudo systemctl status badvpn

    # Configurar el firewall
    sudo ufw allow $puerto_escucha/udp

    echo -e "${COL_TEXT}BadVPN-UDP instalado y configurado en el puerto $puerto_escucha.${NC}"
    sleep 2
    menu_badvpn_udp
}

# Función para redefinir puertos de BadVPN-UDP
redefinir_puertos_badvpn() {
    clear
    echo -e "${COL_HEADER}Puertos actuales de BadVPN-UDP:${NC}"
    sudo netstat -tuln | grep badvpn
    echo -e "${COL_MENU}[1] > AGREGAR PUERTO BADVPN-UDP${NC}"
    echo -e "${COL_MENU}[2] > ELIMINAR PUERTO BADVPN-UDP${NC}"
    echo -e "${COL_ERROR}[0] > VOLVER${NC}"
    echo -n "Seleccione una opción: "
    read opcion

    case $opcion in
        1) agregar_puerto_badvpn ;;
        2) eliminar_puerto_badvpn ;;
        0) menu_badvpn_udp ;;
        *) echo -e "${COL_ERROR}Opción inválida${NC}"; sleep 2; redefinir_puertos_badvpn ;;
    esac
}

# Función para agregar puerto de BadVPN-UDP
agregar_puerto_badvpn() {
    echo -n "Ingrese el puerto a agregar: "
    read puerto
    sudo nohup badvpn-udpgw --listen-addr 0.0.0.0:$puerto > /dev/null 2>&1 &
    sudo ufw allow $puerto/udp
    echo -e "${COL_TEXT}Puerto $puerto agregado a BadVPN-UDP.${NC}"
    sleep 2
    redefinir_puertos_badvpn
}

# Función para eliminar puerto de BadVPN-UDP
eliminar_puerto_badvpn() {
    echo -n "Ingrese el puerto a eliminar: "
    read puerto
    sudo pkill -f "badvpn-udpgw --listen-addr 0.0.0.0:$puerto"
    sudo ufw delete allow $puerto/udp
    echo -e "${COL_TEXT}Puerto $puerto eliminado de BadVPN-UDP.${NC}"
    sleep 2
    redefinir_puertos_badvpn
}

# Función para desinstalar BadVPN-UDP
desinstalar_badvpn() {
    sudo systemctl stop badvpn
    sudo systemctl disable badvpn
    sudo rm /etc/systemd/system/badvpn.service
    sudo apt-get remove --purge -y badvpn
    echo -e "${COL_TEXT}BadVPN-UDP desinstalado.${NC}"
    sleep 2
    menu_badvpn_udp
}

# Iniciar el menu badvpn_udp
menu_badvpn_udp