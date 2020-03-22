#!/bin/bash

declare -r instrucciones="./otros/Instalar zshelldoc.txt"
declare  nombreScript="./../PrioridadMayorContinuaReubicable.sh"
declare nombreAdoc="./zsdoc/PrioridadMayorContinuaReubicable.sh.adoc"
declare -r archivoCabecera="./otros/cabecera.txt"
#Debería sera automático, antes de la línea FUNCTION
declare -r nLineasOcupaCabeceraSucia=12
# Nombre: scanfSiNo
# Descripcion: asigna un valor valido a una variable desde el teclado
# @param $1: texto a imprimir en pantalla para pedir si o no
# @param $2: variable al que se asigna si o no
scanfSiNo() {
	local opcionSiNo
	echo -n "$1" 
	read -r opcionSiNo
	until [[ $opcionSiNo = s || $opcionSiNo = n || $opcionSiNo = S || $opcionSiNo = N ]]; do
		echo "El valor '$opcionSiNo' introducido no válido, tiene que ser 's' o 'n'. Vuelve a intentarlo."
		echo -n "$1" 
		read -r opcionSiNo
	done
	eval ${2}=$opcionSiNo #asignamos la opcionSiNo valida al variable $2 pasado como parametro
}

documentar(){
    local -i opcion
    local opcionSiNoDoc

    echo ""
    echo "¿Qué desea hacer?"
    echo " 1) Generar .adoc"
    if [[ -f $nombreAdoc ]]; then
        echo " 2) Generar .html a partir del .adoc"
        echo " 3) Generar .pdf a partir del .adoc"
    fi
    echo " *) Salir"

    echo -n "> "
    read -r opcion
    
    case $opcion in
    1)
        zsd $nombreScript --bash
        reemplazarCabecera

    ;;
    2) 
        asciidoctor $nombreAdoc
    ;;
    3)
        asciidoctor -b pdf -r asciidoctor-pdf $nombreAdoc
    ;;
    *)
        exit 0
    ;;
    esac
    
    scanfSiNo "¿Desea realizar otra opción? [s/n]" opcionSiNoDoc

    if [[ $opcionSiNoDoc = "s" ]]; then
        echo "Documentando de nuevo"
        documentar
    fi
}

reemplazarCabecera(){
    local -i nLineas
    local -i nLineasLeer
    local opcionReemplazar

    #Mostramos y dejamos escoger si queremos cargar la nueva cabecera
    echo -e "\n----------------------\nCabecera Nueva:"
    cat "$archivoCabecera"
    scanfSiNo "¿Desea reemplazar la cabecera por defecto con la cabecera personalizada? [s/n] " opcionReemplazar
    if [[ $opcionReemplazar != "s" ]];then
        return 0
    fi

    temp=$(mktemp)

    nLineas=$(wc -l < $nombreAdoc)
    
    nLineasLeer=$(( nLineas - nLineasOcupaCabeceraSucia ))

    cat $archivoCabecera >> "$temp"

    tail -$nLineasLeer $nombreAdoc >> "$temp"
    
    cat "$temp" > $nombreAdoc

    rm "$temp"
    
}

# Método Raiz
main() {

    if [[ ! -f $instrucciones ]]; then
        echo "El archivo de instrucciones ./${instrucciones} no se encuentra en el directorio"
        exit 0
    else
        local resultado
        scanfSiNo "¿Desea visualizar las instrucciones de uso? [s/n]" resultado

        if [[ $resultado = "s" ]]; then
            cat "$instrucciones"
            echo -e "\n---------------------------------------------\n"
        fi
    fi

    if [[ ! -f "$nombreScript" ]]; then
        echo "El script $nombreScript no exite."
        echo "Introduzca la ruta del script que desea generar la documentación:"
        echo -n "> "
        read -ers nombreScript -p 
        nombreAdoc=""
    fi

    documentar

    #Copiamos los archivos finales
    local opcionFinal
    scanfSiNo "Desea generar los archivos finales (mover los archivos a ./../Documentación y borrar los archivos temporales) [s/n]: " opcionFinal
    if [[ $opcionFinal = "s" ]]; then 
        rm -rf ./zsdoc/data
        cp -Rf zsdoc/. ./
        rm -rf ./zsdoc/
    fi
}

main