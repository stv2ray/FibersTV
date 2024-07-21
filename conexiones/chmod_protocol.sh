#!/bin/bash
# Script para otorgar permisos de ejecución a todos los archivos de protocolo

# Otorgar permisos de ejecución a cada archivo de protocolo
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
