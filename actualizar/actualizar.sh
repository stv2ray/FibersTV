#!/bin/bash

# Definición de colores
HEADER_COLOR='\e[38;5;105m'  # #6F4BFO
OPTION_COLOR='\e[38;5;39m'   # #006BFA
STATUS_COLOR='\e[38;5;82m'   # #3CF4F3
NC='\e[0m'                   # Sin color
BOX_COLOR='\e[48;5;250m'     # Fondo de caja
BOX_TEXT_COLOR='\e[38;5;0m'  # Texto dentro de la caja

# Variables de GitHub
REPO_URL="https://github.com/stv2ray/FibersTV.git"
TOKEN="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"

# Función para actualizar el script desde GitHub
actualizar_desde_github() {
    clear
    echo -e "${HEADER_COLOR}══════════════════════════════════════════════════════════════════════════════════${NC}"
    echo -e "${HEADER_COLOR}                            ACTUALIZAR DESDE GITHUB${NC}"
    echo -e "${HEADER_COLOR}══════════════════════════════════════════════════════════════════════════════════${NC}"
    
    read -p "¿Desea actualizar el script desde GitHub? (sí/no): " confirmacion
    if [[ $confirmacion == "sí" ]]; then
        echo -e "${BOX_COLOR}${BOX_TEXT_COLOR}  Clonando el repositorio...  ${NC}"
        git clone https://$TOKEN@github.com/stv2ray/FibersTV.git /root/FibersTV_update
        if [[ $? -eq 0 ]]; then
            echo -e "${STATUS_COLOR}Actualización completada con éxito.${NC}"
            echo -e "Presione cualquier tecla para volver al menú."
            read -n 1
            rm -rf /root/FibersTV
            mv /root/FibersTV_update /root/FibersTV
        else
            echo -e "${RED}Error al actualizar el repositorio.${NC}"
            echo -e "Presione cualquier tecla para volver al menú."
            read -n 1
        fi
    else
        echo -e "${RED}Actualización cancelada.${NC}"
        echo -e "Presione cualquier tecla para volver al menú."
        read -n 1
    fi
}

# Función para enviar actualización a GitHub
enviar_actualizacion_a_github() {
    clear
    echo -e "${HEADER_COLOR}══════════════════════════════════════════════════════════════════════════════════${NC}"
    echo -e "${HEADER_COLOR}                       ENVIAR ACTUALIZACIÓN A GITHUB${NC}"
    echo -e "${HEADER_COLOR}══════════════════════════════════════════════════════════════════════════════════${NC}"
    
    read -p "¿Desea enviar la actualización al repositorio de GitHub? (sí/no): " confirmacion
    if [[ $confirmacion == "sí" ]]; then
        cd /root/FibersTV
        git add .
        git commit -m "Actualización del script"
        git push https://$TOKEN@github.com/stv2ray/FibersTV.git
        if [[ $? -eq 0 ]]; then
            echo -e "${STATUS_COLOR}Actualización enviada con éxito.${NC}"
        else
            echo -e "${RED}Error al enviar la actualización.${NC}"
        fi
    else
        echo -e "${RED}Envío de actualización cancelado.${NC}"
    fi
}

# Menú de actualización
menu_actualizar() {
    clear
    echo -e "${HEADER_COLOR}══════════════════════════════════════════════════════════════════════════════════${NC}"
    echo -e "${HEADER_COLOR}                            MENÚ DE ACTUALIZACIÓN${NC}"
    echo -e "${HEADER_COLOR}══════════════════════════════════════════════════════════════════════════════════${NC}"
    echo -e "${BOX_COLOR}${BOX_TEXT_COLOR}  [1] > Actualizar desde GitHub${NC}"
    echo -e "${BOX_COLOR}${BOX_TEXT_COLOR}  [2] > Enviar actualización a GitHub${NC}"
    echo -e "${BOX_COLOR}${BOX_TEXT_COLOR}  [0] > Volver${NC}"
    echo -e "${HEADER_COLOR}══════════════════════════════════════════════════════════════════════════════════${NC}"
    echo -n "Seleccione una opción: "
    read opcion

    case $opcion in
        1) actualizar_desde_github ;;
        2) enviar_actualizacion_a_github ;;
        0) menu_principal ;;  # Asegúrate de tener esta función definida en tu menú principal
        *) echo -e "${RED}Opción inválida${NC}"; sleep 2 ;;
    esac
}

# Llamar al menú de actualización
menu_actualizar
