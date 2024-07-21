#!/bin/bash
# Script para otorgar permisos de ejecución a todos los archivos de protocolo

# Cambiar permisos de ejecución a todos los archivos en las subcarpetas de 'conexiones'
find ~/FibersTV/conexiones -type f -name "*.sh" -exec chmod +x {} \;

echo "Permisos de ejecución otorgados a todos los archivos de protocolo."
