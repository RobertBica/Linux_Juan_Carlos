#!/bin/bash
# autor: Robert

# Variable con el nombre del fichero (cámbialo si lo necesitas)
fichUOS="usuarios.txt"

fntFuncion1() {
    if [ -f "$fichUOS" ]; then
        echo "Contenido del fichero $fichUOS:"
        echo "--------------------------------"
        while IFS= read -r linea; do
            echo "$linea"
        done < "$fichUOS"
        echo "--------------------------------"
    else
        echo "ERROR: El fichero $fichUOS no existe"
    fi
}

fntFuncion2() {
    echo "Función 2 ejecutada"
    echo "Fecha y hora actual:"
    date
}

#################################
# PROGRAMA PRINCIPAL
#################################

while true; do
    clear
    echo "****************************"
    echo "**********  MENÚ  **********"
    echo "****************************"
    echo
    echo "1) Función 1 - Mostrar contenido de $fichUOS"
    echo "2) Función 2"
    echo "3) Salir"
    echo
    read -p "Introduce una opción (1-3): " opcion

    case "$opcion" in
        1)
            fntFuncion1
            read -p "Pulsa [Enter] para continuar..."
            ;;
        2)
            fntFuncion2
            read -p "Pulsa [Enter] para continuar..."
            ;;
        3)
            clear
            echo "Saliendo del programa..."
            sleep 1
            exit 0
            ;;
        *)
            echo "Error: Opción no válida"
            read -p "Pulsa [Enter] para continuar..."
            ;;
    esac
done
