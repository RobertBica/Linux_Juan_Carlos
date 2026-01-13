#!/bin/bash
# Script corregido para carpetas compartidas por grupos en Linux (Ubuntu/Debian)

# 1. Crear directorios 
mkdir -p /pub/Documentación/Direccion
mkdir -p /pub/Documentación/Informatica

# 2. Crear grupos (si no existen)
groupadd -f Direccion_RW     # -f evita error si ya existe
groupadd -f Informatica_RW

# 3. Añadir usuarios a los grupos (suponiendo que ya existen los usuarios)
# Cambia los nombres si son diferentes
usermod -aG Direccion_RW  usuario_Direcc
usermod -aG Informatica_RW usuario_Inf

# 4. Cambiar grupo propietario + aplicar permisos + setgid
# Recomendado: 2770 → propietario rwx, grupo rwx, otros nada, + setgid

# Para Dirección
chgrp -R Direccion_RW /pub/Documentación/Direccion
chmod -R 2770 /pub/Documentación/Direccion          # 2770 = drwxrws--- (s = setgid)

# Para Informática
chgrp -R Informatica_RW /pub/Documentación/Informatica
chmod -R 2770 /pub/Documentación/Informatica

# Opcional: propietario root (o un usuario admin), pero grupo manda
# chown -R root:Direccion_RW /pub/Documentación/Direccion   ← si quieres root como dueño

echo "Configuración final:"
echo "----------------------------------------"
ls -ld /pub/Documentación/Direccion
ls -ld /pub/Documentación/Informatica
getent group Direccion_RW
getent group Informatica_RW
echo "----------------------------------------"
echo "¡Listo! Los nuevos archivos heredarán el grupo gracias al bit setgid (s)."
echo "Los miembros del grupo pueden crear, modificar y eliminar en su carpeta."
echo "Prueba: haz login con usuario_Direcc y crea un archivo en /pub/Documentación/Direccion"
