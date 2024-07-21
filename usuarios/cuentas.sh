#!/bin/bash

# Definición de colores
BLUE='\e[38;5;69m'         # #6F4BFO
LIGHT_BLUE='\e[38;5;123m'  # #CED4F5
AQUA='\e[38;5;50m'         # #3CF4F3
LIGHT_GREEN='\e[38;5;119m' # #EAFFF8
DARK_BLUE='\e[38;5;32m'    # #006BFA
RED='\e[38;5;196m'         # #FF0000
NC='\e[0m'                 # Sin color

# Rutas de archivos
LIMITS_FILE="/root/FibersTV/cuentas/limits.conf"
PASSWORD_FILE="/root/FibersTV/cuentas/passwords.txt"

# Función para mostrar el menú de cuentas
menu_cuentas() {
    while true; do
        clear
        LIMITADOR=$(grep "LIMITADOR" "$LIMITS_FILE" | cut -d'=' -f2)
        echo -e "${LIGHT_BLUE}====================================${NC}"
        echo -e "${DARK_BLUE}           MENÚ DE CUENTAS          ${NC}"
        echo -e "${LIGHT_BLUE}====================================${NC}"
        echo -e "${GREEN}[1] > NUEVO USUARIO SSH${NC}"
        echo -e "${GREEN}[2] > REMOVER USUARIO${NC}"
        echo -e "${GREEN}[3] > EDITAR USUARIO${NC}"
        echo -e "${GREEN}[4] > DETALLES DE TODOS USUARIOS${NC}"
        echo -e "${GREEN}[5] > MONITOR DE USUARIOS CONECTADOS${NC}"
        echo -e "${GREEN}[6] > LIMITADOR-DE-CUENTAS [$LIMITADOR]${NC}"
        echo -e "${GREEN}[7] > BACKUP USUARIOS${NC}"
        echo -e "${RED}[0] > VOLVER${NC}"
        echo -e "${LIGHT_BLUE}====================================${NC}"
        echo -n "Seleccione una opción: "
        read opcion

        case $opcion in
            1) nuevo_usuario_ssh ;;
            2) remover_usuario ;;
            3) editar_usuario ;;
            4) detalles_usuarios ;;
            5) monitor_usuarios_conectados ;;
            6) limitador_cuentas ;;
            7) backup_usuarios ;;
            0) menu_principal ;;  # Asegúrate de tener esta función definida en tu menú principal
            *) echo -e "${RED}Opción inválida${NC}"; sleep 2 ;;
        esac
    done
}

# Función para crear un nuevo usuario SSH
nuevo_usuario_ssh() {
    clear
    echo -e "${LIGHT_BLUE}====================================${NC}"
    echo -e "${DARK_BLUE}      Crear Nuevo Usuario SSH      ${NC}"
    echo -e "${LIGHT_BLUE}====================================${NC}"
    echo -n "Usuario: "
    read usuario
    echo -n "Contraseña: "
    read -s password
    echo
    echo -n "Duración (días): "
    read duracion
    echo -n "Límite de conexión: "
    read limite

    # Crear el usuario y establecer la contraseña
    useradd -M -s /bin/false "$usuario"
    echo "$usuario:$password" | chpasswd

    # Guardar la contraseña en un archivo separado
    echo "$usuario:$password" >> "$PASSWORD_FILE"

    # Configurar la fecha de caducidad
    chage -E $(date -d "$duracion days" +%Y-%m-%d) "$usuario"

    # Configurar el límite de conexión (usando pam_limits)
    echo "$usuario hard maxlogins $limite" >> /etc/security/limits.conf

    echo -e "${GREEN}Usuario $usuario creado con éxito.${NC}"
    sleep 2
}

# Función para listar los usuarios
listar_usuarios() {
    awk -F':' '{ if ($3 >= 1000 && $3 != 65534) print $1 }' /etc/passwd
}

# Función para eliminar un usuario SSH
remover_usuario() {
    clear
    echo -e "${LIGHT_BLUE}====================================${NC}"
    echo -e "${DARK_BLUE}       Usuarios Registrados        ${NC}"
    echo -e "${LIGHT_BLUE}====================================${NC}"
    listar_usuarios
    echo -n "Seleccione el usuario a eliminar: "
    read usuario

    # Eliminar el usuario
    userdel -r "$usuario"
    sed -i "/^$usuario /d" /etc/security/limits.conf
    sed -i "/^$usuario:/d" "$PASSWORD_FILE"

    echo -e "${GREEN}Usuario $usuario eliminado con éxito.${NC}"
    sleep 2
}

# Función para editar un usuario SSH
editar_usuario() {
    clear
    echo -e "${LIGHT_BLUE}====================================${NC}"
    echo -e "${DARK_BLUE}       Editar Usuario SSH          ${NC}"
    echo -e "${LIGHT_BLUE}====================================${NC}"
    echo -e "${LIGHT_BLUE}Usuarios registrados:${NC}"
    listar_usuarios
    echo -n "Seleccione el usuario a editar: "
    read usuario

    echo -e "${LIGHT_BLUE}====================================${NC}"
    echo -e "${DARK_BLUE}    Editar usuario $usuario         ${NC}"
    echo -e "${LIGHT_BLUE}====================================${NC}"
    echo -n "Nueva contraseña: "
    read -s password
    echo
    echo -n "Nueva duración (días): "
    read duracion
    echo -n "Nuevo límite de conexión: "
    read limite

    # Cambiar la contraseña del usuario
    echo "$usuario:$password" | chpasswd

    # Guardar la nueva contraseña en el archivo separado
    sed -i "/^$usuario:/d" "$PASSWORD_FILE"
    echo "$usuario:$password" >> "$PASSWORD_FILE"

    # Configurar la nueva fecha de caducidad
    chage -E $(date -d "$duracion days" +%Y-%m-%d) "$usuario"

    # Configurar el nuevo límite de conexión (usando pam_limits)
    sed -i "/^$usuario /d" /etc/security/limits.conf
    echo "$usuario hard maxlogins $limite" >> /etc/security/limits.conf

    echo -e "${GREEN}Usuario $usuario editado con éxito.${NC}"
    sleep 2
}

# Función para mostrar detalles de todos los usuarios
detalles_usuarios() {
    clear
    echo -e "${LIGHT_BLUE}====================================${NC}"
    echo -e "${DARK_BLUE}   Detalles de Todos los Usuarios   ${NC}"
    echo -e "${LIGHT_BLUE}====================================${NC}"
    listar_usuarios | while read usuario; do
        password=$(grep "^$usuario:" "$PASSWORD_FILE" | cut -d: -f2)
        limite=$(grep "^$usuario " /etc/security/limits.conf | awk '{print $4}')
        caducidad=$(chage -l "$usuario" | grep "Account expires" | cut -d: -f2)
        echo -e "${GREEN}Usuario: $usuario${NC}"
        echo -e "${GREEN}Contraseña: $password${NC}"
        echo -e "${GREEN}Límite de conexión: $limite${NC}"
        echo -e "${GREEN}Días restantes: $caducidad${NC}"
        echo "-----------------------------"
    done
    echo "Presione cualquier tecla para volver."
    read -n 1
}

# Función para monitorizar usuarios conectados
monitor_usuarios_conectados() {
    clear
    echo -e "${LIGHT_BLUE}====================================${NC}"
    echo -e "${DARK_BLUE}  Monitor de Usuarios Conectados    ${NC}"
    echo -e "${LIGHT_BLUE}====================================${NC}"
    who | while read usuario tty _; do
        tiempo_conectado=$(ps -o etime= -p $(pgrep -t "$tty") | xargs)
        echo -e "${GREEN}Usuario: $usuario${NC}"
        echo -e "${GREEN}Tiempo conectado: $tiempo_conectado${NC}"
        echo "-----------------------------"
    done
    echo "Presione cualquier tecla para volver."
    read -n 1
}

# Función para ajustar el límite de cuentas
limitador_cuentas() {
    clear
    echo -e "${LIGHT_BLUE}====================================${NC}"
    echo -e "${DARK_BLUE}     Ajustar Límite de Cuentas      ${NC}"
    echo -e "${LIGHT_BLUE}====================================${NC}"
    echo -n "Nuevo límite: "
    read nuevo_limite
    sed -i "/^LIMITADOR/d" "$LIMITS_FILE"
    echo "LIMITADOR=$nuevo_limite" >> "$LIMITS_FILE"
    echo -e "${GREEN}Límite de cuentas ajustado a $nuevo_limite.${NC}"
    sleep 2
}

# Función para realizar backup de usuarios
backup_usuarios() {
    clear
    echo -e "${LIGHT_BLUE}====================================${NC}"
    echo -e "${DARK_BLUE}         Backup de Usuarios         ${NC}"
    echo -e "${LIGHT_BLUE}====================================${NC}"
    fecha=$(date +%Y%m%d%H%M%S)
    backup_file="/root/FibersTV/cuentas/backup_$fecha.txt"
    cp "$PASSWORD_FILE" "$backup_file"
    echo -e "${GREEN}Backup realizado con éxito en $backup_file.${NC}"
    sleep 2
}

# Función principal del menú de cuentas
menu_principal() {
    # Aquí debes definir el menú principal, si aún no está definido.
    echo "Volviendo al menú principal..."
    sleep 2
    # Por ejemplo:
    # source /root/FibersTV/FibersTV.sh
}

# Llamar a la función del menú de cuentas para iniciar
menu_cuenta
