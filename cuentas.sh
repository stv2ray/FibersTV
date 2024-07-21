#!/bin/bash

# Definición de colores
COL_BANNER1="\e[38;5;69m"   # #6F4BFO
COL_BANNER2="\e[38;5;117m"  # #CED4F5
COL_BANNER3="\e[38;5;33m"   # #006BFA
COL_BANNER4="\e[38;5;119m"  # #EAFFF8
COL_HEADER="\e[38;5;69m"    # #6F4BFO
COL_MENU="\e[38;5;69m"      # #6F4BFO
COL_TEXT="\e[38;5;69m"      # #6F4BFO
COL_ERROR="\e[38;5;196m"    # Rojo
NC='\e[0m'                  # Sin color

# Rutas de archivos
LIMITS_FILE="/root/FibersTV/limits.conf"
PASSWORD_FILE="/root/FibersTV/passwords.txt"

# Crear archivos si no existen
[ ! -f "$LIMITS_FILE" ] && touch "$LIMITS_FILE" && echo "LIMITADOR=10" >> "$LIMITS_FILE"
[ ! -f "$PASSWORD_FILE" ] && touch "$PASSWORD_FILE"

# Función para mostrar el menú de cuentas
menu_cuentas() {
    while true; do
        clear
        LIMITADOR=$(grep "LIMITADOR" "$LIMITS_FILE" | cut -d'=' -f2)
        echo -e "===================================="
        echo -e "${COL_BANNER2}           MENÚ DE CUENTAS          ${NC}"
        echo -e "===================================="
        echo -e "${COL_MENU}[1] > NUEVO USUARIO SSH${NC}"
        echo -e "${COL_MENU}[2] > REMOVER USUARIO${NC}"
        echo -e "${COL_MENU}[3] > EDITAR USUARIO${NC}"
        echo -e "${COL_MENU}[4] > DETALLES DE TODOS USUARIOS${NC}"
        echo -e "${COL_MENU}[5] > MONITOR DE USUARIOS CONECTADOS${NC}"
        echo -e "${COL_MENU}[6] > LIMITADOR-DE-CUENTAS [$LIMITADOR]${NC}"
        echo -e "${COL_MENU}[7] > BACKUP USUARIOS${NC}"
        echo -e "${COL_ERROR}[0] > VOLVER${NC}"
        echo -e "===================================="
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
            0) break ;;  # Salir del bucle para volver al menú principal
            *) echo -e "${COL_ERROR}Opción inválida${NC}"; sleep 2 ;;
        esac
    done
}

# Función para crear un nuevo usuario SSH
nuevo_usuario_ssh() {
    clear
    echo -e "${COL_BANNER2}====================================${NC}"
    echo -e "${COL_BANNER3}      Crear Nuevo Usuario SSH      ${NC}"
    echo -e "${COL_BANNER2}====================================${NC}"
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

    echo -e "${COL_TEXT}Usuario $usuario creado con éxito.${NC}"
    sleep 2
}

# Función para listar los usuarios
listar_usuarios() {
    awk -F':' '{ if ($3 >= 1000 && $3 != 65534) print $1 }' /etc/passwd
}

# Función para eliminar un usuario SSH
remover_usuario() {
    clear
    echo -e "${COL_BANNER2}====================================${NC}"
    echo -e "${COL_BANNER3}       Usuarios Registrados        ${NC}"
    echo -e "${COL_BANNER2}====================================${NC}"
    listar_usuarios
    echo -n "Seleccione el usuario a eliminar: "
    read usuario

    # Eliminar el usuario
    userdel -r "$usuario"
    sed -i "/^$usuario /d" /etc/security/limits.conf
    sed -i "/^$usuario:/d" "$PASSWORD_FILE"

    echo -e "${COL_TEXT}Usuario $usuario eliminado con éxito.${NC}"
    sleep 2
}

# Función para editar un usuario SSH
editar_usuario() {
    clear
    echo -e "${COL_BANNER2}====================================${NC}"
    echo -e "${COL_BANNER3}       Editar Usuario SSH          ${NC}"
    echo -e "${COL_BANNER2}====================================${NC}"
    echo -e "${COL_BANNER2}Usuarios registrados:${NC}"
    listar_usuarios
    echo -n "Seleccione el usuario a editar: "
    read usuario

    echo -e "${COL_BANNER2}====================================${NC}"
    echo -e "${COL_BANNER3}    Editar usuario $usuario         ${NC}"
    echo -e "${COL_BANNER2}====================================${NC}"
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

    echo -e "${COL_TEXT}Usuario $usuario editado con éxito.${NC}"
    sleep 2
}

# Función para mostrar detalles de todos los usuarios
detalles_usuarios() {
    clear
    echo -e "${COL_BANNER2}====================================${NC}"
    echo -e "${COL_BANNER3}   Detalles de Todos los Usuarios   ${NC}"
    echo -e "${COL_BANNER2}====================================${NC}"
    listar_usuarios | while read usuario; do
        password=$(grep "^$usuario:" "$PASSWORD_FILE" | cut -d: -f2)
        limite=$(grep "^$usuario " /etc/security/limits.conf | awk '{print $4}')
        caducidad=$(chage -l "$usuario" | grep "Account expires" | cut -d: -f2)
        echo -e "${COL_TEXT}Usuario: $usuario${NC}"
        echo -e "${COL_TEXT}Contraseña: $password${NC}"
        echo -e "${COL_TEXT}Límite de conexión: $limite${NC}"
        echo -e "${COL_TEXT}Días restantes: $caducidad${NC}"
        echo "-----------------------------"
    done
    echo "Presione cualquier tecla para volver."
    read -n 1
}

# Función para monitorizar usuarios conectados
monitor_usuarios_conectados() {
    clear
    echo -e "${COL_BANNER2}====================================${NC}"
    echo -e "${COL_BANNER3}  Monitor de Usuarios Conectados    ${NC}"
    echo -e "${COL_BANNER2}====================================${NC}"
    who | while read usuario tty _; do
        tiempo_conectado=$(ps -o etime= -p $(pgrep -t "$tty") | xargs)
        echo -e "${COL_TEXT}Usuario: $usuario${NC}"
        echo -e "${COL_TEXT}Tiempo conectado: $tiempo_conectado${NC}"
        echo "-----------------------------"
    done
    echo "Presione cualquier tecla para volver."
    read -n 1
}

# Función para ajustar el límite de cuentas
limitador_cuentas() {
    clear
    echo -e "${COL_BANNER2}====================================${NC}"
    echo -e "${COL_BANNER3}     Ajustar Límite de Cuentas      ${NC}"
    echo -e "${COL_BANNER2}====================================${NC}"
    echo -n "Nuevo límite: "
    read nuevo_limite
    sed -i "/^LIMITADOR/d" "$LIMITS_FILE"
    echo "LIMITADOR=$nuevo_limite" >> "$LIMITS_FILE"
    echo -e "${COL_TEXT}Límite de cuentas ajustado a $nuevo_limite.${NC}"
    sleep 2
}

# Función para realizar backup de usuarios
backup_usuarios() {
    clear
    echo -e "${COL_BANNER2}====================================${NC}"
    echo -e "${COL_BANNER3}         Backup de Usuarios         ${NC}"
    echo -e "${COL_BANNER2}====================================${NC}"
    fecha=$(date +%Y%m%d%H%M%S)
    backup_file="/root/FibersTV/backup_$fecha.txt"
    cp "$PASSWORD_FILE" "$backup_file"
    echo -e "${COL_TEXT}Backup realizado con éxito en $backup_file.${NC}"
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
menu_cuentas
