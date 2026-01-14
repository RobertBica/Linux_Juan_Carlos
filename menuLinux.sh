#!/bin/bash
# autor: jcrequena (base) + adaptado por Iván

ROOT="/mnt/gestor"     # Ruta raíz por defecto
CURRENT=""             # Ruta de trabajo actual (curso)
ETAPA=""
CURSO=""

pause() {
  read -p "Pulsa [Enter] para continuar..."
}

error() {
  echo "ERROR: $1"
}

# Comprueba que ROOT existe y tiene las carpetas esperadas
check_root() {
  if [[ ! -d "$ROOT" ]]; then
    error "La ruta ROOT no existe: $ROOT"
    return 1
  fi
  return 0
}

# Seleccionar etapa y curso -> fija CURRENT
select_ruta_curso() {
  check_root || return 1

  echo "Ruta actual ROOT: $ROOT"
  echo
  echo "Selecciona etapa:"
  echo "1) ESO"
  echo "2) BACH"
  echo "3) DAW"
  read -p "Opción: " op

  case "$op" in
    1) ETAPA="ESO" ;;
    2) ETAPA="BACH" ;;
    3) ETAPA="DAW" ;;
    *) error "Opción no válida"; return 1 ;;
  esac

  echo
  echo "Cursos disponibles en $ETAPA:"
  # Lista carpetas dentro de la etapa
  if [[ ! -d "$ROOT/$ETAPA" ]]; then
    error "No existe la etapa en el ROOT: $ROOT/$ETAPA"
    return 1
  fi

  # Mostrar cursos y permitir elegir
  mapfile -t cursos < <(ls -1 "$ROOT/$ETAPA" 2>/dev/null)
  if [[ ${#cursos[@]} -eq 0 ]]; then
    error "No hay cursos dentro de $ROOT/$ETAPA"
    return 1
  fi

  i=1
  for c in "${cursos[@]}"; do
    echo "$i) $c"
    ((i++))
  done

  read -p "Elige curso (número): " n
  if ! [[ "$n" =~ ^[0-9]+$ ]] || (( n < 1 || n > ${#cursos[@]} )); then
    error "Selección inválida"
    return 1
  fi

  CURSO="${cursos[$((n-1))]}"
  CURRENT="$ROOT/$ETAPA/$CURSO"

  echo
  echo "Ruta seleccionada: $CURRENT"
  return 0
}

# 1) Cambiar ROOT
fntCambiarRoot() {
  read -p "Introduce nueva ruta ROOT (ej. /mnt/gestor): " newroot
  if [[ -z "$newroot" ]]; then
    error "Ruta vacía"
    return 1
  fi
  ROOT="$newroot"
  CURRENT=""
  ETAPA=""
  CURSO=""
  check_root || return 1
  echo "ROOT actualizada a: $ROOT"
}

# 2) Seleccionar curso
fntSeleccionarCurso() {
  select_ruta_curso
}

# 3) Listar contenido del curso seleccionado
fntListar() {
  if [[ -z "$CURRENT" ]]; then
    error "No hay curso seleccionado. Usa la opción 'Seleccionar curso'."
    return 1
  fi
  echo "Listado de: $CURRENT"
  ls -la "$CURRENT"
}

# 4) Crear archivo dentro del curso seleccionado
fntCrearArchivo() {
  if [[ -z "$CURRENT" ]]; then
    error "No hay curso seleccionado."
    return 1
  fi
  read -p "Nombre del archivo a crear (ej. nota.txt): " fname
  if [[ -z "$fname" ]]; then
    error "Nombre vacío"
    return 1
  fi
  # Crear archivo
  touch "$CURRENT/$fname" 2>/dev/null || { error "No se pudo crear (¿permisos?)"; return 1; }
  echo "Archivo creado: $CURRENT/$fname"
}

# 5) Eliminar archivo dentro del curso seleccionado
fntEliminarArchivo() {
  if [[ -z "$CURRENT" ]]; then
    error "No hay curso seleccionado."
    return 1
  fi
  read -p "Nombre del archivo a eliminar (ej. nota.txt): " fname
  if [[ -z "$fname" ]]; then
    error "Nombre vacío"
    return 1
  fi
  rm -i "$CURRENT/$fname" 2>/dev/null || { error "No se pudo eliminar (¿existe? ¿permisos?)"; return 1; }
  echo "Eliminación completada (si confirmaste)."
}

#################################
# PROGRAMA PRINCIPAL
#################################

while true; do
  clear
  echo "****************************"
  echo "****** MENU GESTOR *********"
  echo "****************************"
  echo
  echo "ROOT:    $ROOT"
  echo "CURSO:   ${CURRENT:-<no seleccionado>}"
  echo
  echo "1) Cambiar ruta ROOT del gestor"
  echo "2) Seleccionar etapa/curso"
  echo "3) Listar archivos del curso"
  echo "4) Crear archivo en el curso"
  echo "5) Eliminar archivo del curso"
  echo "6) Salir"
  echo

  read -p "Introduce una opción: " opcion

  case "$opcion" in
    1) fntCambiarRoot; pause ;;
    2) fntSeleccionarCurso; pause ;;
    3) fntListar; pause ;;
    4) fntCrearArchivo; pause ;;
    5) fntEliminarArchivo; pause ;;
    6) echo "Saliendo..."; exit 0 ;;
    *) echo "Opción inválida"; pause ;;
  esac
done
