#!/bin/bash
# Script para otorgar o quitar permisos de ejecución a todos los archivos de protocolo

# Función para otorgar permisos de ejecución
otorgar_permisos() {
    chmod +x /root/FibersTV/conexiones/dropbear/dropbear.sh
    chmod +x /root/FibersTV/conexiones/socks_python/socks_python.sh
    chmod +x /root/FibersTV/conexiones/ssl/ssl.sh
    chmod +x /root/FibersTV/conexiones/v2ray/v2ray.sh
    chmod +x /root/FibersTV/conexiones/websocket/websocket.sh
    chmod +x /root/FibersTV/conexiones/badvpn_udp/badvpn_udp.sh
    chmod +x /root/FibersTV/conexiones/squid/squid.sh
    chmod +x /root/FibersTV/conexiones/openvpn/openvpn.sh
    chmod +x /root/FibersTV/conexiones/slowdns/slowdns.sh
    chmod +x /root/FibersTV/conexiones/wireguard/wireguard.sh
    chmod +x /root/FibersTV/conexiones/udp/udp.sh
    chmod +x /root/FibersTV/conexiones/psiphon/psiphon.sh
    chmod +x /root/FibersTV/conexiones/ws_epro/ws_epro.sh
    echo "Permisos de ejecución otorgados a todos los archivos de protocolo."
}

# Función para quitar permisos de ejecución
quitar_permisos() {
    chmod -x /root/FibersTV/conexiones/dropbear/dropbear.sh
    chmod -x /root/FibersTV/conexiones/socks_python/socks_python.sh
    chmod -x /root/FibersTV/conexiones/ssl/ssl.sh
    chmod -x /root/FibersTV/conexiones/v2ray/v2ray.sh
    chmod -x /root/FibersTV/conexiones/websocket/websocket.sh
    chmod -x /root/FibersTV/conexiones/badvpn_udp/badvpn_udp.sh
    chmod -x /root/FibersTV/conexiones/squid/squid.sh
    chmod -x /root/FibersTV/conexiones/openvpn/openvpn.sh
    chmod -x /root/FibersTV/conexiones/slowdns/slowdns.sh
    chmod -x /root/FibersTV/conexiones/wireguard/wireguard.sh
    chmod -x /root/FibersTV/conexiones/udp/udp.sh
    chmod -x /root/FibersTV/conexiones/psiphon/psiphon.sh
    chmod -x /root/FibersTV/conexiones/ws_epro/ws_epro.sh
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