#!/bin/bash
# Script para otorgar o quitar permisos de ejecución a todos los archivos de protocolo

# Lista de carpetas de protocolos
protocolos=("dropbear" "socks_python" "ssl" "v2ray" "websocket" "badvpn_udp" "squid" "openvpn" "slowdns" "wireguard" "udp" "psiphon" "ws_epro")

# Función para otorgar permisos de ejecución
otorgar_permisos() {
    for protocolo in "${protocolos[@]}"; do
        find ~/FibersTV/conexiones/$protocolo -type f -name "*.sh" -exec chmod +x {} \;
    done
    echo "Permisos de ejecución otorgados a todos los archivos de protocolo."
}

# Función para quitar permisos de ejecución
quitar_permisos() {
    for protocolo in "${protocolos[@]}"; do
        find ~/FibersTV/conexiones/$protocolo -type f -name "*.sh" -exec chmod -x {} \;
    done
    echo "Permisos de ejecución quitados a todos los archivos de protocolo."
}

# Mostrar submenú
echo "Seleccione una opción:"
echo "1) Otorgar permisos"
echo "2) Quitar permisos"
echo "0) Volver"
read opcion

case $opcion in
    1) otorgar_permisos ;;
    2) quitar_permisos ;;
    0) exit 0 ;;
    *) echo "Opción inválida"; exit 1 ;;
esac