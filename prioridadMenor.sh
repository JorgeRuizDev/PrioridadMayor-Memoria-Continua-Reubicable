#!/bin/bash

resize -s 50 120 >/dev/null
clear

echo -e "\e[0;36m			╔══════════════════════════════════════════════════════════╗\e[0m"
echo -e "\e[0;36m			║\e[0m                     Creative Commons                     \e[0;36m║\e[0m"
echo -e "\e[0;36m			║\e[0m                                                          \e[0;36m║\e[0m"
echo -e "\e[0;36m			║\e[0m                   BY - Atribución (BY)                   \e[0;36m║\e[0m"
echo -e "\e[0;36m			║\e[0m                 NC - No uso Comercial (NC)               \e[0;36m║\e[0m"
echo -e "\e[0;36m			║\e[0m                 SA - Compartir Igual (SA)                \e[0;36m║\e[0m"
echo -e "\e[0;36m			╚══════════════════════════════════════════════════════════╝\e[0m\n"

echo "		╔══════════════════════════════════════════════════════════╗" > informePrioridadMenor.txt
echo "		║                     Creative Commons                     ║" >> informePrioridadMenor.txt
echo "		║                                                          ║" >> informePrioridadMenor.txt
echo "		║                   BY - Atribución (BY)                   ║" >> informePrioridadMenor.txt
echo "		║                 NC - No uso Comercial (NC)               ║" >> informePrioridadMenor.txt
echo "		║                 SA - Compartir Igual (SA)                ║" >> informePrioridadMenor.txt
echo "		╚══════════════════════════════════════════════════════════╝" >> informePrioridadMenor.txt

echo -e "\e[0;36m		╔═══════════════════════════════════════════════════════════════════════════════╗\e[0m"
echo -e "\e[0;36m		║\e[0m										\e[0;36m║\e[0m"
echo -e "\e[0;36m		║\e[0m			     Algoritmo de Prioridad Menor			\e[0;36m║\e[0m"
echo -e "\e[0;36m		║\e[0m				Base: Omar Santos Bernabé			\e[0;36m║\e[0m"
echo -e "\e[0;36m		║\e[0m										\e[0;36m║\e[0m"
echo -e "\e[0;36m		║\e[0m			  Alumnos: Xing Long Ji - Yi Peng Ji			\e[0;36m║\e[0m"
echo -e "\e[0;36m		║\e[0m			    Asignatura: Sistemas Operativos			\e[0;36m║\e[0m"
echo -e "\e[0;36m		║\e[0m				  Curso 2016-2017				\e[0;36m║\e[0m"
echo -e "\e[0;36m		║\e[0m										\e[0;36m║\e[0m"
echo -e "\e[0;36m		╚═══════════════════════════════════════════════════════════════════════════════╝\e[0m\n"
echo "" >>informePrioridadMenor.txt

echo `tput sitm`Me gusta hacer poles`tput sgr0`

echo "	╔═══════════════════════════════════════════════════════════════════════════════╗" >> informePrioridadMenor.txt
echo "	║										║" >> informePrioridadMenor.txt
echo "	║				Informe de Práctica				║" >> informePrioridadMenor.txt
echo "	║			     Algoritmo de Prioridad Menor			║" >> informePrioridadMenor.txt
echo "	║										║" >> informePrioridadMenor.txt
echo "	║			  Alumnos: Xing Long Ji - Yi Peng Ji			║" >> informePrioridadMenor.txt
echo "	║			    Asignatura: Sistemas Operativos			║" >> informePrioridadMenor.txt
echo "	║				  Curso 2016-2017				║" >> informePrioridadMenor.txt
echo "	║										║" >> informePrioridadMenor.txt
echo "	╚═══════════════════════════════════════════════════════════════════════════════╝" >> informePrioridadMenor.txt
echo "" >>informePrioridadMenor.txt

#declaracion de variables



declare opcionApropiativo
declare opcionEstatico
declare -A procesos
declare -a memoria
declare -a cabeceraProcesos=("PID" "NOMBRE PROCESO" "T.LLEGADA" "T.EJECUCIÓN" "PRIORIDAD" "MEMORIA" "T.EJEC.REST" "T.ESPERA" "T.RETORNO" "ESTADO ACTUAL")
declare -a cola
declare -r numCol=5
declare -i numProc=0
declare -i procesoCPU=0
declare -i partCPU=0
declare priorMin
declare priorMax
declare numeroParticiones
declare tamPart
declare tamCola=0
declare tipoPrioridad
declare abrirInforme

#Según Necesidades (2020):
declare tamMemoria=15
declare memoriaLibre

#FIXME borrame loko
memoriaLibre=$tamMemoria




# Memoria según necesidades es el array bidimensional en el que se almacenará la información de la memoria
# No tengo intención de hacer un algoritmo eficiente para la memoria, por el simple hecho de 
# que puede ser poco intuitivo para alumnos de primero
#
# Más adelante se explicará como estarán organizadas estas capas de memoria, y el contenido específico que almacenará cada capa
declare -A memoriaSegunNecesidades
#La memoria será un array bidimensional con N capas y M huecos, siendo M = tamMemoria
#Así podremos almacenar que proceso se almacena en cada hueco.

#Capa donde se guardaran los índices/Apuntadores/punteros de el proceso que se encuentra en cada posición de memoria respecto a la tabla de $procesos[]
declare -r MEM_INDICE=0	

#Capa donde se almacena el texto a imprimir
declare -r MEM_TOSTRING=1

declare -r MEM_HUECO_VACIO="null"
declare -r MEM_STRING_HUECO_VACIO="-"
declare -r MEM_STRING_HUECOSINCOLOR=" "
#Colores de texto
#ejemplo: echo -e "${B_RED}texto en rojo negrita${GREEN}texto en verde${NC}"
declare -r DEFAULT='\e[39m' #Color por defecto
declare -r BLACK='\e[30m'
declare -r RED='\e[31m'
declare -r GREEN='\e[32m'
declare -r YELLOW='\e[33m'
declare -r BLUE='\e[34m'
declare -r MAGENTA='\e[35m'
declare -r CYAN='\e[36m'
declare -r L_GRAY='\e[36m' #Gris claro
declare -r D_GRAY='\e[90m' #Gris oscuro
declare -r L_RED='\e[91m' #Rojo claro
declare -r L_GREEN='\e[92m' #Verde claro
declare -r L_YELLOW='\e[93m' #Amarillo claro
declare -r L_BLUE='\e[94m' #Azul claro
declare -r L_MAGENTA='\e[95m' #Magenta claro
declare -r L_CYAN='\e[96m' #Cyan claro
declare -r WHITE='\e[97m'
#Colores en negrita
declare -r BOLD='\e[1;39m'
declare -r B_BLACK='\e[1;30m'
declare -r B_RED='\e[1;31m'
declare -r B_GREEN='\e[1;32m'
declare -r B_YELLOW='\e[1;33m'
declare -r B_BLUE='\e[1;34m'
declare -r B_MAGENTA='\e[1;35m'
declare -r B_CYAN='\e[1;36m'
declare -r B_L_GRAY='\e[1;36m' #Gris claro
declare -r B_D_GRAY='\e[1;90m' #Gris oscuro
declare -r B_L_RED='\e[1;91m' #Rojo claro
declare -r B_L_GREEN='\e[1;92m' #Verde claro
declare -r B_L_YELLOW='\e[1;93m' #Amarillo claro
declare -r B_L_BLUE='\e[1;94m' #Azul claro
declare -r B_L_MAGENTA='\e[1;95m' #Magenta claro
declare -r B_L_CYAN='\e[1;96m' #Cyan claro
declare -r B_WHITE='\e[1;97m'
#Fin de color
declare -r NC='\e[0m' 

#Colores de FONDO:
declare -r _GREEN='\e[42m'
declare -r _RED='\e[41m'
declare -r _YELLOW='\e[43m'

#	######################################
#	Declares 2020:
#	######################################

# Variable de control de BREAKPOINTS 
#//@see breakpoint
declare BREAKPOINT_ENABLED=true

#Valores de la estructura/struc (El array bidimensional procesos)
#//@see procesos
#Los siguientes valores (1-9) son las posiciones del struct existentes a las versiones previas a 2020
declare -r P_NOMBRE=1		#	$P_NOMBRE
declare -r P_TLLEGADA=2		#	$P_TLLEGADA
declare -r P_TEJECUCION=3	#	$P_TEJECUCION
declare -r P_PRIORIDAD=4	#	$P_PRIORIDAD
declare -r P_TAMANIO=5		#	$P_TAMANIO
declare -r P_TRESTANTE=6	#	$P_TRESTANTE
declare -r P_TESPERA=7		#	$P_TESPERA
declare -r P_TRETORNO=8		#	$P_TRETORNO
declare -r P_ESTADO=9		#	$P_ESTADO

#Valores 2020:
declare -r P_PID=0
declare -r P_COLOR=10


#Strings de estados/STATUS (Valores a asignar a P_ESTADO)
declare -r STAT_MEMO="Memo."
declare -r STAT_ENCPU="En CPU"
declare -r STAT_COLA="Cola"
declare -r STAT_FIN="Fin"



#Ficheros:
declare -r INFORME_FILENAME="informePrioridadMayor.txt"


#DEBUG (Variables globales):
declare -r DEFAULT_DEBUG_OUTPUT_FILE_NAME="debug.txt"
declare -r DEBUG_ENABLE=true
declare -r DEBUG_FIRST_EXECUTION=true
declare -r DEBUG_PERSISTENT_FILE=false






#TODO generales:
#	-Verificación de que el script se está ejecutando desde ./script.sh ó script.sh, y que no hay más carpetas antes.
#	
#
#
#
#
#
#
#
#





# Nombre: escribirInforme
# Descripcion: escribe en el archivo informePrioridadMenor.txt
# @param $1: texto a escribir en el informe
# @param $2 (opcional): argumento para el echo como -n si no se quiere introducir un salto de linea
escribirInforme(){
	echo $2 -e "$1" >> informePrioridadMenor.txt
}

# Nombre: imprimirAviso
# Descripcion: imprime en pantalla un aviso de error al introducir un dato con letras.
# @param $1: texto de aviso 
# Cambios 2020: Como hemos añadido la funcion imprimirErrorCritico, he cambiado el color de fondo de ROJO a AMARILLO/NARANJA (Depende del terminal)
imprimirAviso(){
	echo -e "\n${B_BLACK}${_YELLOW}\xE2\x9A\xA0  $1 ${NC}\n" #\xE2\x9A\xA0 significa icono de alerta
}

# Nombre: imprimirErrorCritico
# Descripcion: imprime en pantalla un aviso de error al introducir un dato con letras.
# @param $1: texto de aviso
imprimirErrorCritico(){
	echo -e "\n${B_BLACK}${_RED}❌  $1 ${NC}\n"
}

# Nombre: salirPorErroCritico
# Descripcion: imprime en pantalla un aviso de error al introducir un dato con letras y para la ejecucion.
# @param $1: texto de aviso
# Date 21/02/2020
#//@see  ErrorCritio
#//@see  forzarCierre
salirPorErrorCritico(){
	imprimirErrorCritico "$1"
	forzarCierre
}

# Nombre: forzarCierre
# Descripcion: Ejecuta una serie de comandos antes de salir, perfecta para borrar archivo u otras cosas por si no es válida la ejecución!
# Date: 21/02/2020
# //@see deleteGeneratedFiles
forzarCierre(){
	local buffer
	imprimirErrorCritico "Cerrando por fallo, pulse [Enter] para continuar"
	read buffer

	#Funciones a ejecutar aquí abajo: {

		deleteGeneratedFiles



	#	}

	clear
	fin_programa
}


# Nombre: FuncionDeTesteo
# Descripción: Función simple que ejecuta un código aislado, sin ensuciar el main
# Detalles: Es necesario llegar hasta el final del archivo para cargar todas las funciones, si se queire probar algo que no ha sido cargado, es un poco incómod
# esta función puede ser tratada como un main aislado, el objetivo es probar el código de años anteriores sin necesidad de ejecutar todo el programa
# Date: 21/02/2020
funcionDeTesteo(){

	salirPorErrorCritico "Se entero de que los kapopers no bieneron a su ciudad"

}

# Nombre: imprimirLCyan
# Descripcion: imprime en pantalla el text de color cyan claro
# @param $1: texto a imprimir en cyan claro
# @param $2 (opcional): argumento adicional para el echo como -n si no se quiere introducir un salto de linea
imprimirLCyan(){
	echo -e $2 ${L_CYAN}$1${NC}
}

# Nombre: fin_programa
# Descripcion: se termina la ejecición del script
fin_programa(){
	imprimirLCyan "Saliendo del programa"
	exit    
}

# Nombre: scanfSiNo
# Descripcion: asigna un valor valido a una variable desde el teclado
# @param $1: texto a imprimir en pantalla para pedir si o no
# @param $2: variable al que se asigna si o no
scanfSiNo() {
	local opcionSiNo
	imprimirLCyan "$1" -n 
	read opcionSiNo
	until [[ $opcionSiNo = s || $opcionSiNo = n || $opcionSiNo = S || $opcionSiNo = N ]]; do
		imprimirAviso "El valor '$opcionSiNo' introducido no válido, tiene que ser 's' o 'n'. Vuelve a intentarlo."
		imprimirLCyan "$1" -n
		read opcionSiNo
	done
	eval ${2}=$opcionSiNo #asignamos la opcionSiNo valida al variable $2 pasado como parametro
}

# Nombre: scanfNum
# Descripcion: asigna un valor mayor que un numero pasado como parametro a una variable desde el teclado
# @param $1: texto a imprimir en pantalla para pedir
# @param $2: variable al que se asigna el numero valido
# @param $3: numero minimo valido
scanfNum(){
	local opcionN
	imprimirLCyan "$1" -n
	read opcionN
    #$opcionN -eq $opcionN comprueba si es un numero, si es una letra da error enviado al vacio
	until [ $opcionN -eq $opcionN -a $opcionN -ge  $3 ] 2>/dev/null; do
		imprimirAviso "El valor '$opcionN' introducido no válido, tiene que ser mayor que $3."
		imprimirLCyan "$1" -n	
		read opcionN
	done
	eval ${2}=$opcionN
}

# Nombre: scanfNumMinMax
# Descripcion: asigna un valor entre un rango de numeros desde el teclado
# @param $1: texto a imprimir para pedir el numero
# @param $2: variable al que se asigna el numero valido
# @param $3: numero mínimo del rango (incluido)
# @param $4: numero máximo del rango (incluido)
scanfNumMinMax(){
	local opcionN
	local numMinimo=$3
	local numMaximo=$4
	#si el numMinimo es mas grande que numMaximo intercambia las variables
	if [ $numMinimo -gt $numMaximo ]; then 
		numMinimo=$4
		numMaximo=$3
	fi

	imprimirLCyan "$1" -n
	read opcionN
	until [ $opcionN -eq $opcionN -a $opcionN -le $numMaximo -a $opcionN -ge $numMinimo ] 2>/dev/null; do 
		imprimirAviso "El valor '$opcionN' introducido no válido, intervalo válido [ $numMinimo, $numMaximo ]."
		imprimirLCyan "$1" -n	
		read opcionN
	done
	eval ${2}=$opcionN
}

# Nombre: scanfString
# Descripcion: asigna un valor cadena de caracteres a una variable pasado como parametro
# @param $1: texto a imprimir para pedir la cadena de caracteres
# @param $2: variable al que se asigna la cadena valida
scanfString(){
	local opcionNombre
	local -i palabra
	imprimirLCyan "$1" -n
	read opcionNombre
	palabra=`echo $opcionNombre | wc -w`
	while [ $palabra -ne 1 ]; do #comprueba si está vacío o tiene un espacio
		imprimirAviso "No puede ser vacío ni tener espacios."
		imprimirLCyan "$1" -n
		read opcionNombre
		palabra=`echo $opcionNombre | wc -w`
	done
	eval ${2}=$opcionNombre
}

# Nombre: numAleatorio
# Descripcion: genera un numero aleatorio de un rango de dos numeros pasado como parametro
# @param $1: variable a asignar el número aleatorio
# @param $2: número mmáximo del rango incluido
# @param $3: número máximo del rango incluido
numAleatorio(){
	local num
	local numMinimo=$2
	local numMaximo=$3
	if [ $numMinimo -gt $numMaximo ]; then
		numMinimo=$3
		numMaximo=$2
	fi
	num=$(( $RANDOM % ($numMaximo+1-$numMinimo) + $numMinimo ))
	eval ${1}=$num
}

# Nombre: comprobarRango
# Descripcion: comprueba número se encuentra dentro de un rango de dos números, 
# si no se encuetra dentro llama a scanfNumMinMax para modificarlo
# @param $1: el texto que se imprime en caso de que el número no se encuentre dentro del rango o no sea un número
# @param $2: el número a comprobar si encuentra dentro del rango
# @param $3: variable a modificar si el numero no se encuentra dentro del rango
# @param $4: numero mínimo del rango incluido
# @param $5: numero máximo del rango incluido
comprobarRango(){
	local numMinimo=$4
	local numMaximo=$5
	if [ $numMinimo -gt $numMaximo ]; then
		numMinimo=$5
		numMaximo=$4
	fi
	if ! [ $2 -eq $2 -a $2 -ge $numMinimo -a $2 -le $numMaximo ] 2>/dev/null; then
		scanfNumMinMax "$1" $3 $numMinimo $numMaximo
	fi
}

# Nombre: comprobarRepite
# Descripcion: comprueba el nombre del proceso se esta repitiendo
# @param $1: posicion del proceso del array procesos
comprobarRepite(){
	local -i i
	local boolean=1
	for (( i=1; i<=numProc&&boolean==1; i++)) do
		if  [ ${procesos[$i,$P_NOMBRE]} = ${procesos[$1,$P_NOMBRE]} -a $i -ne $1 ] 2>/dev/null; then
			boolean=0
			scanfString "El nombre del proceso ${procesos[$1,$P_NOMBRE]} ya existe. Introduce otro nombre: " procesos[$1,$P_NOMBRE]
			comprobarRepite $1
		fi
	done

}

# Nombre: comprobarSN
# Descripcion: comprueba si un número es un s o un n. Solo se usa en datos por fichero
# @param $1: el texto a imprimir en pantalla en caso de valor no válido
# @param $2: valor de la variable a comprobar
# @param $3: variable a modificar en caso de valor no válido
comprobarSN(){
	if ! [[ $2 = "s" || $2 = "n" || $2 = "S" || $2 = "N" ]]; then
		scanfSiNo "$1" "$3"
	fi
} 

# Nombre cargaDatos
# Descripcion: muestra las opciones de inicio del programa si los datos es por fichero, teclado o automáticos
cargaDatos(){
	local -i opcionUsuario
	local masProc="s"
	local -i i
	echo -e " ${L_YELLOW}╔════════════════════════════════════╗
 ║${NC}${B_BLUE}¿Como quieres introducir los datos? ${NC}${L_YELLOW}║
 ║                                    ║
 ║${NC} 1-Por teclado                      ${L_YELLOW}║
 ║${NC} 2-Por fichero                      ${L_YELLOW}║
 ║${NC} 3-Datos automáticos                ${L_YELLOW}║
 ║${NC} 4-Salir del programa               ${L_YELLOW}║
 ║                                    ║
 ╚════════════════════════════════════╝${NC}\n"
	scanfNumMinMax "Elige opción: " opcionUsuario 1 4
    case $opcionUsuario in
	1)
		menuAlgoritmo
		clear
		imprimirLCyan "Has elegido Apropiativo: $opcionApropiativo y Estatico: $opcionEstatico"
		scanfNum "¿Tamaño de la particion?: " tamPart 1
		scanfNum "¿Número de particiones? " numeroParticiones 1
		scanfNumMinMax "¿Prioridad mínima?" priorMin -10000 10000 
		scanfNumMinMax "¿Prioridad máxima?" priorMax -10000 10000
		establecerPrioridad 
		while [ $masProc = "s" ]; do
			((numProc++))
			datosManualProcesos $numProc
			scanfSiNo "¿Quieres meter mas procesos? [s/n]:" masProc
		done
	;;
	2)
		datosFichero
	;;
    3)
		menuAlgoritmo
		datosAleatorios
	;;
	4)
		fin_programa
	;;
	esac
	#copia en la columna 6 el tiempo de ejecución. La columna 6 se usa como T.Ejec restante
	
	#TODO: Añádir en esta zona: Asignación de PID; Asignación Color
	#		Igual añadir una función que asigne el T_restante / inicialice. 
	for ((i=1;i<=$numProc;i++)) do
		procesos[$i,$P_TRESTANTE]=${procesos[$i,$P_TEJECUCION]}
	done
}

# Nombre: menuAlgoritmo
# Descripcion: menu para elegir las opciones del algoritmo, más info en la opcion 5 Ayuda (glosario)
menuAlgoritmo(){
	local -i i
	local opcion
	clear
	echo -e "\n ${L_YELLOW}╔════════════════════════════════════════════╗
 ║${NC}${B_BLUE} ¿Como quieres el algoritmo?                ${NC}${L_YELLOW}║
 ║                                            ║
 ║${NC} 1-No Apropiativo y Estático                ${L_YELLOW}║
 ║${NC} 2-Apropiativo y Estático                   ${L_YELLOW}║
 ║${NC} 3-No apropiativo y No Estático (Dinámico)  ${L_YELLOW}║
 ║${NC} 4-Apropiativo y No estático (Dinámico)     ${L_YELLOW}║
 ║${NC} 5-Ayuda (glosario)                         ${L_YELLOW}║
 ║${NC} 6-Salir del programa                       ${L_YELLOW}║
 ║                                            ║
 ╚════════════════════════════════════════════╝${NC}\n"
	scanfNumMinMax "Elige opción: " opcion 1 7
	case $opcion in
		1) opcionApropiativo="n"
		opcionEstatico="s";;
		2) opcionApropiativo="s"
		opcionEstatico="s";;
		3) opcionApropiativo="n"
		opcionEstatico="n";;
		4) opcionApropiativo="s"
		opcionEstatico="n";;
		5) clear
	echo -e "\n ${L_YELLOW}╔═════════════════════════════════════════════════════════════════════════════════╗
 ║                                                                                 ║
 ║${NC}${B_L_GREEN} Apropiativo:${NC} El proceso que se está ejecutando puede ser expulsado              ${L_YELLOW}║
 ║${NC} de la CPU cuando haya otro proceso con menor prioridad en la memoria.           ${L_YELLOW}║
 ║                                                                                 ║
 ║${NC}${B_L_GREEN} No apropiativo:${NC} El proceso que se está ejecutando no puede ser                  ${L_YELLOW}║
 ║${NC} expulsado de la memoria, solo sale cuando termina su tiempo de ejecución.       ${L_YELLOW}║
 ║                                                                                 ║
 ║${NC}${B_L_GREEN} Estático:${NC} La prioridad de los procesos en memoria no disminuyen                 ${L_YELLOW}║
 ║${NC} a lo largo de la ejecución de los procesos.                                     ${L_YELLOW}║
 ║                                                                                 ║
 ║${NC}${B_L_GREEN} Dinámico:${NC} La prioridad de los procesos en memoria disminuyen                   ${L_YELLOW} ║
 ║${NC} a lo largo de la ejecución de los procesos. En este script se                   ${L_YELLOW}║
 ║${NC} disminuirá (prioridad Menor) en uno al finalizar la ejecución de un proceso.    ${L_YELLOW}║
 ║${NC} En caso contrario aumentará al finalizar la ejecución de un proceso.            ${L_YELLOW}║
 ║                                                                                 ║
 ╚═════════════════════════════════════════════════════════════════════════════════╝${NC}\n"
		imprimirLCyan "Intro para salir de la ayuda" -n
		read -s
		menuAlgoritmo;;
		6) fin_programa;;
	esac

}

# Nombre: breakpoint
# Date: 21/02/2020
# Descripción: Permite realizar una parada del programa en cualquier punto del código hasta que no se realizar una entrada por teclado.
# Uso: Activar o desactivar la variable global $BREAKPOINT_ENABLED para activar o desactivar los breakpoints.
# Globales: BREAKPOINT_ENABLED
# @param $@: Imprime todos los stings pasados como argumento, por si se quieren visualizar variables. 
breakpoint(){
	
	if [[ $BREAKPOINT_ENABLED = true ]]; then
		local bufferTemporal

		if (($# == 0));then 
			echo -n ">"
		else
			echo -n "Breakpoint > $1"
		fi

		read bufferTemporal 

	fi
}

# Nombre: debug (y sus muchas funciones)
# Date: 21/02/2020
# Descripción: Permite imprimir un string en un fichero a parte, y que este sea visualizado desde otro terminal
# Uso: alternar los booleanos globales
# Globales:DEFAULT_DEBUG_OUTPUT_FILE_NAME, DEBUG_ENABLE, DEBUG_FIRST_EXECUTION, DEBUG_PERSISTENT_FILE
# @param $1: String a imprimir
debug(){
  
  if [[ $DEBUG_ENABLE == false ]]; then
    return 0
  fi

  mensajeEntadaDebug(){
    printf "Introduzca el comando \$tail -f $DEFAULT_DEBUG_OUTPUT_FILE_NAME para obtener el debug\n"
   
  }
  cleanDebugFile(){
    if [[ $DEBUG_PERSISTENT_FILE == false ]]; then
     echo "" > $DEFAULT_DEBUG_OUTPUT_FILE_NAME
    fi
  }

  cabeceraDebug(){
    printf "%s\n-----------------------------------------------\n" "$(date '+%d/%m/%Y %H:%M:%S')" >> $DEFAULT_DEBUG_OUTPUT_FILE_NAME

  }


  if [[ $DEBUG_FIRST_EXECUTION == true ]]; then
    cleanDebugFile
    mensajeEntadaDebug
    cabeceraDebug
    DEBUG_FIRST_EXECUTION=false
  fi
  echo -e "$1" >> $DEFAULT_DEBUG_OUTPUT_FILE_NAME
  
}

# Nombre: deleteGeneratedFiles
# Date: 21/02/2020
# Descripción: Borra aquellos archivos que han sido generados por el programa. Es necesario indicar los archivos a borrar
# Uso: Añadir los archvios, pereferiblemente, comprobar antes de borrar si existen
deleteGeneratedFiles(){
	if [[ -f $DEFAULT_DEBUG_OUTPUT_FILE_NAME ]]; then
		rm $DEFAULT_DEBUG_OUTPUT_FILE_NAME >> /dev/null
	fi

	if [[ -f $DEFAULT_LOG_FILE_NAME ]]; then
		rm $DEFAULT_LOG_FILE_NAME >> /dev/null
	fi
#TOFILL
}


# Nombre: establecerPrioridad
# Descripcion: establece el tipo de prioridad considerando priorMin y priorMax. El valor se usara para comparar en la ejecución
#
# Nota 2020:
# Globales: tipoPrioridad
establecerPrioridad(){
	#si priorMin es un número más pequeño que priorMax el tipo de prioridad es menor
	if [ $priorMin -le $priorMax ]; then
		tipoPrioridad="-lt"
	else #si priorMin es un número más grande que priorMax el tipo de prioridad es técnicamente mayor
		tipoPrioridad="-gt"
	fi
}

# Nombre: datosManualProcesos
# Descripcion: el usuario rellena los datos de cada proceso por teclado: nombre, t.llegada, t.ejecución, prioridad y tamaño 
# @param $1: índice del proceso dentro del array procesos
datosManualProcesos(){
	local seguro
	local -i j
	clear
	imprimirTabla 1 2 3 4 5
	#TODO: Nombre procesos autómaticos
	scanfString "Nombre del proceso $1: " procesos[$1,$P_NOMBRE]
	comprobarRepite $1
	clear
	imprimirTabla 1 2 3 4 5
	scanfNum "¿Tiempo de llegada del proceso $1?: " procesos[$1,$P_TLLEGADA] 0
	clear
	imprimirTabla 1 2 3 4 5
	scanfNum "¿Tiempo de ejecución del proceso $1?: " procesos[$1,$P_TEJECUCION] 1
	clear
	imprimirTabla 1 2 3 4 5
	scanfNumMinMax "¿Prioridad del proceso $1?: " procesos[$1,$P_PRIORIDAD] $priorMin $priorMax
	clear
	imprimirTabla 1 2 3 4 5
	#TODO: Sustituir por el tamaño máximo de la memoria. 
	scanfNumMinMax "¿Tamaño del proceso $1? (Menor o igual del tamaño de partición [$tamPart] ): " procesos[$1,$P_TAMANIO] 1 $tamPart
	clear
	imprimirTabla 1 2 3 4 5
	scanfSiNo "¿Estas seguro de los datos del último proceso introducido? [s/n]: " seguro
	if [ $seguro = "n" ]; then #si se cumple se borra la fila que acaba de introducir los datos
		for ((j=1; j<=numCol;j++)) do
			unset procesos[$1,$j]
		done
		datosManualProcesos $1
	fi
}

# Nombre: datosFichero
# Descripcion: Opción 2: Por datos. Recoge todos los datos a través del fichero
datosFichero(){
	local -i i
	local -i j
	local -i k #linea del fichero de los datos de procesos
	local nomFile=datos.txt
	local respuesta
	local numLineas
	scanfSiNo "Por defecto se usa datos.txt ¿Quieres cambiarlo? [s/n]: " respuesta
	if [ $respuesta = "s" ]; then
		scanfString "Nombre del fichero: " nomFile
	fi
	if [ -f $nomFile ]; then #si el fichero existe
		imprimirLCyan "Cargando datos desde $nomFile"
		sleep 1
		numLineas=`cat $nomFile | wc -l`
		#sed -n 1p coge la linea 1 y cut -d ":" -f 2 la columna 2 delimitado por :
		tamPart=`sed -n 1p $nomFile | cut -d ":" -f 2`
		numeroParticiones=`sed -n 2p $nomFile | cut -d ":" -f 2`
		opcionApropiativo=`sed -n 3p $nomFile | cut -d ":" -f 2`
		opcionEstatico=`sed -n 4p $nomFile | cut -d ":" -f 2`
		priorMin=`sed -n 5p $nomFile | cut -d ":" -f 2`
		priorMax=`sed -n 6p $nomFile | cut -d ":" -f 2`
		for (( i=1,k=8; k<=numLineas; i++,k++)) do
			((numProc++))
			for (( j=1; j<=numCol; j++ )) do
				procesos[$i,$j]=`sed -n ${k}p $nomFile| cut -d "	" -f $j`
			done
		done
		comprobarDatosFichero
		establecerPrioridad
	else #si no existe el fichero vuelve a mandar al menú de inicio
		imprimirAviso "$nomFile no existe. Volviendo al menú de inicio..."
		sleep 2
		clear
		cargaDatos
	fi
}

# Nombre: comprobarDatosFichero
# Descripcion: comprueba si los datos del fichero son correctos. Si se repite el nombre de los procesos, fuera de rango en tamaño de procesos etc.
comprobarDatosFichero(){
	local -i i
	local -i j
	#TODO: Sustituir particiones por el tamaño de memoria.
	#TODO: Eliminar número de particiones.
	
	comprobarRango "El tamaño de particiones es incorrecto, tendrás que introducir por teclado otro número: " $tamPart tamPart 1 999999
	comprobarRango "El número de particiones es incorrecto, tendrás que introducir por teclado otro número: " $numeroParticiones numeroParticiones 1 999999
	comprobarSN "Opcion apropiativo incorrecto, tendrás que introducir por teclado [s/n]:" $opcionApropiativo opcionApropiativo
	for ((i=1;i<=numProc;i++)) do
		for((j=1;j<=numCol;j++)) do
			case "$j" in
				1)
					comprobarRepite $i 
				;;
				2)
					comprobarRango "El tiempo de llegada del proceso ${procesos[$i,$P_NOMBRE]} es incorrecto, introduce otro número: " ${procesos[$i,$j]} procesos[$i,$j] 0 999999 
				;;
				3)
					comprobarRango "El tiempo de ejecución del proceso ${procesos[$i,$P_NOMBRE]} es incorrecto, introduce otro número: " ${procesos[$i,$j]} procesos[$i,$j] 1 999999 
				;;
				4)
					comprobarRango "La prioridad del proceso ${procesos[$i,$P_NOMBRE]} es incorrecto, introduce otro número: " ${procesos[$i,$j]} procesos[$i,$j] $priorMin $priorMax 
				;;
				5)
					comprobarRango "El tamaño del proceso ${procesos[$i,$P_NOMBRE]} es incorrecto, introduce otro número: " ${procesos[$i,$j]} procesos[$i,$j] 1 $tamPart 
				;;
			esac
		done
	done
}

# Nombre: datosAleatorios
# Descripcion: Opción 3: Datos Aleatorios. Carga datos del número y tamaño de partición, 
# número de procesos, etc con números aleatorios llamando a la función numAleatorio
datosAleatorios(){
	local -i i
	numAleatorio tamPart 1 100 #aleatorio de tamaño de partición
	tamPart=$[$tamPart * 10] #multiplicamos por 10 para que acabe en 0 el tamaño particion, es meramente estetico
	numAleatorio numeroParticiones 1 7 
	numAleatorio numProc 5 12
	numAleatorio priorMin -30 30
	numAleatorio priorMax -30 30
	establecerPrioridad
	for ((i=1; i<=numProc; i++)) do 
		procesos[$i,$P_NOMBRE]="P$i"
		numAleatorio procesos[$i,$P_TLLEGADA] 0 15 #numero aleatorio de t.llegada entre 0 y 15
		numAleatorio procesos[$i,$P_TEJECUCION] 1 10 #numero aleatorio de t.ejec entre 0 y 10		
		numAleatorio procesos[$i,$P_PRIORIDAD] $priorMin $priorMax #numero aleatorio de prioridad entre prioriMin y priorMax
		numAleatorio procesos[$i,$P_TAMANIO] 1 $tamPart #numero aleatorio de tamaño entre 1 y tamPart
	done
}

# Nombre: escribeDatos
# Descripcion: sobrescribe los datos en datos.txt, si no existe lo crea
escribeDatos(){
	local -i i
	local -i j
	echo "Tamaño particiones:$tamPart" > datos.txt
	echo "Numero de particiones:$numeroParticiones" >> datos.txt
	echo "Apropiativo:$opcionApropiativo" >> datos.txt
	echo "Estatico:$opcionEstatico" >> datos.txt
	echo "Prioridad Mínima:$priorMin" >> datos.txt
	echo "Prioridad Máxima:$priorMax" >> datos.txt
	echo -e "Nombre\tT.Lleg\tT.Ejec\tPrior\tTamaño" >> datos.txt
	for (( i=1; i<=numProc; i++ )) do
		for(( j=1; j<=numCol; j++ )) do
			echo -e -n "${procesos[$i,$j]}\t" >> datos.txt
		done
		echo  >> datos.txt
	done
}

# Nombre: ordenarProcesos
# Descripcion: ordena el array procesos en función del tiempo de llegada.
# Se usa selection sort como algortimo de ordenamiento
ordenarProcesos(){
	local -i i
	local -i j
	local -i minLlegada
	for((i=1;i<numProc;i++)) do
		minLlegada=$i
		for((j=i+1;j<=numProc;j++)) do
			if [ ${procesos[$j,$P_TLLEGADA]} -lt ${procesos[$minLlegada,$P_TLLEGADA]} ]; then #compara el tiempo de llegada
					minLlegada=$j
			fi
		done
		#intercambio de elementos
		for((k=1;k<=6;k++)) do
			aux=${procesos[$i,$k]}
			procesos[$i,$k]=${procesos[$minLlegada,$k]}	
			procesos[$minLlegada,$k]=$aux
		done
	done
}

# Nombre: imprimirTabla
# Descripcion: imprime las columnas del array procesos pasado como parámetro
# @param $@ (todos): índice de las columnas que se quiere imprimir en pantalla
imprimirTabla(){
	local -i i
	local -i j
	local -i k

	for ((k=0;k<$#;k++)) do #imprime la primera linea de la tabla. Depende de la cantidad de columnas
		echo -n -e "$BLUE+---------------"
	done
	echo -e "+${NC}"

	for k in "$@" #imprime la cabecera de la tabla
	do
		echo -e -n "$BLUE|${NC}${B_L_YELLOW}${cabeceraProcesos[$k]}${NC}\t"
	done
	echo -e "$BLUE|${NC}"

	for (( i=1; i<=numProc; i++ )) do 
		if [ $((($i-1) % 5 )) -eq 0 ]; then #imprime una línea de separación cada 5 procesos
			for ((k=0;k<$#;k++)) do 
				echo -n -e "$BLUE+---------------"
			done
			echo -e "+${NC}" 
		fi
		for j in "$@" #imprime los datos de los procesos
		do
				echo -n -e "$BLUE|${NC}${BOLD}${procesos[$i,$j]}${NC}\t\t"

		done
		echo -e "$BLUE|${NC}"

	done

	for ((k=0;k<$#;k++)) do 
		echo -n -e "$BLUE+---------------"
	done
	echo -e "+${NC}"
}

# Nombre: informeTabla
# Descripcion: escribe en el informe las columnas del array procesos pasado como parámetro
# @param $@ (todos): índice de las columnas que se quiere escribir en el informe
informeTabla(){
	local -i i
	local -i j
	local -i k
	for ((k=0;k<$#;k++)) do 
		escribirInforme "+---------------" -n
	done
	escribirInforme "+"
	for k in "$@"
	do
		escribirInforme "|${cabeceraProcesos[$k]}\t" -n
	done
	escribirInforme "|"
	for (( i=1; i<=numProc; i++ )) do
		if [ $((($i-1) % 5 )) -eq 0 ]; then
			for ((k=0;k<$#;k++)) do 
				escribirInforme "+---------------" -n
			done
			escribirInforme "+" 
		fi
		for j in "$@"
		do
			escribirInforme "|${procesos[$i,$j]}\t\t" -n
		done
		escribirInforme "|"
	done
	for ((k=0;k<$#;k++)) do 
		escribirInforme "+---------------" -n
	done
	escribirInforme "+"
}

# Nombre: inicializarArrays
# Descripción: inicializa arrays necesario antes de la ejecución
inicializarArrays(){
	local -i i
	for((i=1;i<=numeroParticiones;i++)) do #ponemos el indice a 0 las particiones
		memoria[$i]=0
	done
    cola[1]=0
	for((i=1;i<=numProc;i++)) do #ponemos a 0 el tiempo de espera de todos los procesos
		procesos[$i,$P_TESPERA]=0
	done
	#inicializamos de datos predeterminados los de la fila 0, fila usada como indice en caso de que una memoria o cpu este vacio
	procesos[0,$P_TLLEGADA]=0
	procesos[0,$P_TAMANIO]=0
	procesos[0,$P_TRESTANTE]=-1
	if [ $tipoPrioridad = "-lt" ]; then
		procesos[0,$P_PRIORIDAD]=$(($priorMax + 1))
	else
		procesos[0,$P_PRIORIDAD]=$(($priorMax - 1))
	fi
}

# Nombre: anadirCola
# Descripcion: añade el indice de un proceso del array procesos al final de la cola,
# cambia el estado del proceso a "cola"
# @param $1: indice del proceso a meter en cola
anadirCola(){
	((tamCola++))
    cola[$tamCola]=$1
	#Actualizamos el estado del proceso a "En cola"
	procesos[$1,$P_ESTADO]=$STAT_COLA
}

# Nombre: eliminarCola
# Descripcion: elimina el primer elemento de la cola y mueve los demas elementos a la izquierda
eliminarCola(){
	local -i i
	local -i j
	for((i=1;i<=tamCola;i++)) do #mueve los elementos a la izquierda
		cola[$i]=${cola[$i+1]}	
	done
    ((tamCola--))
}

# Nombre: anadirMemoria
# Descripcion: añade en una partición vacía el indice de la memoria
# @param $1: indice del proceso a guardar en la particion
# @param $2: modifica la variable con el indice de la particion donde se ha guardado el proceso 
anadirMemoria(){
	local -i i
	local -i bool=0
	for((i=1;i<=numeroParticiones&&bool==0;i++)) do
		if [ ${memoria[$i]} -eq 0 ]; then #comprueba si la particion está vacia
			memoria[$i]=$1
			eval ${2}=$i
			bool=1
			procesos[${cola[1]},$P_ESTADO]=$STAT_MEMO
		fi
	done
}

# Nombre: imprimirParticion
# Descripcion: imprime en pantalla cada una de las particiones siendo de 100 espacios el tamaño de la particion
imprimirParticion(){
	local -i i
	local -i j
	local -i k
	local -i aux
	for ((i=1;i<=numeroParticiones;i++)) do
		aux=$[${procesos[${memoria[$i]},5]} * 100 / $tamPart] # regla de 3 calcula el numero de espacios necesarios para el proceso
		echo -e " ____________________________________________________________________________________________________"
        echo -e -n "|$_RED" # fondo de color rojo para lo que ocupa el proceso
		for ((j=0;j<aux;j++)) do #imprime los _ necesarios para el proceso
			echo -e -n "_"
		done
		echo -e -n "${NC}$_GREEN" # fondo de color verde lo que sobra del proceso
		for ((k=0;k<100-aux;k++)) do #imprime los _ hasta llegar a 100
			echo -e -n "_"
		done
		echo -e "${NC}|${B_BLUE} Particion $i${NC}"
		if [ ${memoria[$i]} -ne 0 ]; then # si no esta vacio la particion muestra los datos del proceso en la particion	
			echo -e "${B_RED} ${procesos[${memoria[$i]},1]} [Prior. ${procesos[${memoria[$i]},$P_PRIORIDAD]}]: ${procesos[${memoria[$i]},5]}M/${tamPart}M ($aux%)${NC}"
		fi
	done
}

# Nombre: escribirParticion
# Descripcion: escribe en el informe las particiones
escribirParticion(){
	local -i i
	local -i porcentaje
	for ((i=1;i<=numeroParticiones;i++)) do
		if [ ${memoria[$i]} -ne 0 ]; then
			porcentaje=$[${procesos[${memoria[$i]},5]} * 100 / ${tamPart}]
			echo "Partición $i: ${procesos[${memoria[$i]},1]} [Prior. ${procesos[${memoria[$i]},$P_PRIORIDAD]}]: ${procesos[${memoria[$i]},5]}M/${tamPart}M ($porcentaje%)" >> temp
		else
			echo "Partición $i: Libre" >> temp
		fi
	done
}


# Nombre: setCPU
# Descripcion: introduce un proceso en CPU si esta libre o hay otro proceso con menor prioridad
# @param $1: boolean que indica si ha habido un cambio en la CPU
#
setCPU(){
	local -i menorPrioridad
	menorPrioridad=$procesoCPU
	for((i=1;i<=numeroParticiones;i++)) do
		
		#FIXME	Esta zona está rota por el linter: No detecta que la variable $tipoPrioridad es un comparador
		
		#
		if [ ${procesos[${memoria[$i]},$P_PRIORIDAD]} -gt ${procesos[$menorPrioridad,$P_PRIORIDAD]} ]; then
			
			zmenorPrioridad=${memoria[$i]}
			partCPU=$i #particion que esta en la cpu
		#si tienen la misma prioridad, se compara los indices de los procesos de la tabla.
		#Como esta ordenado se coge el de menor T.Llegada y si son iguales se coge el primero que se haya escrito
		elif [ ${procesos[${memoria[$i]},$P_PRIORIDAD]} -eq ${procesos[$menorPrioridad,$P_PRIORIDAD]} -a ${memoria[$i]} -lt $menorPrioridad ]; then
			menorPrioridad=${memoria[$i]}
			partCPU=$i
		fi
	done
	if [ $procesoCPU -ne $menorPrioridad ]; then
		procesos[$procesoCPU,$P_ESTADO]=$STAT_MEMO
		procesoCPU=$menorPrioridad
		procesos[$procesoCPU,$P_ESTADO]=$STAT_ENCPU
		eval ${1}=1 #modifica el boolean que se ha pasado por 1, cuando haya una modificacion en el CPU
	else
		eval ${1}=0
	fi
}
#

vaciarMemoria(){
	for((i=1;i<=tamMemoria;i++)); do
		memoriaSegunNecesidades[i,$MEM_INDICE]=$MEM_HUECO_VACIO
		memoriaSegunNecesidades[i,$MEM_TOSTRING]=$MEM_STRING_HUECO_VACIO
	done

}

# Si el proceso tiene un tamaño igual o menor a la memoria libre:
#  -Se introduce el proceso en memoria
#  -Se actualiza su estado a "STAT_MEMO"
#  -Se actualiza la cantidad de memoria libre
# @param $1: indice del proceso a guardar en la particion
aniadirAMemoria(){
	#TODO: inicializar $memoriaLibre en algun lado con el tamaño total de memoria
	#Dicho tamaño de momento va a ser fijo
	debug "Testeando el valor de $memoriaLibre"
	if ((proceso[$1,P_TAMANIO] <= memoriaLibre)); then
		proceso[$1,$P_ESTADO]=$STAT_MEMO
		ajustarMemoriaParaElProceso ${proceso[$1,$P_TAMANIO]}
	fi
}

#
# Funcion que comprueba si un proces cabe en la memoria TOTAL, o es necesario reubicar.
# @param $1: Tamaño del proceso
ajustarMemoriaParaElProceso(){
	local cabeEnMemoria=0
	local numeroDeHuecosLibresConsecutivos=0

	if ((proceso[$1,P_TAMANIO] <= memoriaLibre)); then
		#Contamos el número de posiciones vacias consecutivas
		#Si tienen el mismo tamaño que la memoria, lo enganchamos ahí
		#si hemos recorrido todo el array, y no cabe en ningun lado, reubicamos.

		for((i=1;i<=tamMemoria;i++)); do
			if [[ ${memoriaSegunNecesidades[i,$MEM_INDICE]} -eq $MEM_HUECO_VACIO ]]; then #Si hueco esta vacio
				((numeroDeHuecosLibresConsecutivos++))

				if ((numeroDeHuecosLibresConsecutivos = $1)); then #Si el proceso tiene el tamaño mínimo del hueco comprobado
					cabeEnMemoria=1
					break
				fi
			else
				numeroDeHuecosLibresConsecutivos=0
			fi
		done
	fi

	#FIXME no se si funciona
	if (( cabeEnMemoria == 0)); then
		reubicarProcesos
	fi
}


reubicarProcesos(){
	# Buffer destinado a guardar los elementos que se encuentran en este momento en memoria
	# Almacenará: Un puntero a la fila de la tabla correspondiente a cada proceso
	# Leerá dicho puntero/indice de la tabla de memoria, de la capa MEM_INDICE

	local ultimoIndiceEncontrado="/"
	local -i ultimaPosicionMemoria=1
	#FIXME esto igual no tira: EL unset igual no es correcto
	
	#Vaciamos el array
	unset bufferReubicacion
	declare -a bufferReubicacion

	#Almacenamos los procesos que están en memoria
	for((i=1;i<=tamMemoria;i++)); do
		if [[ ${memoriaSegunNecesidades[i,$MEM_INDICE]} != "$ultimoIndiceEncontrado" ]] && [[ ${memoriaSegunNecesidades[i,$MEM_INDICE]} != "$MEM_HUECO_VACIO" ]]; then
			bufferReubicacion+=("${memoriaSegunNecesidades[i,$MEM_INDICE]}")
		fi
	done
	
	
	for indice in "{bufferReubicacion[@]}"; do
		
		for((i=0;i<procesos[$indice,$P_TAMANIO];i++)); do
			#añadimos el indice
			memoriaSegunNecesidades[$ultimaPosicionMemoria,$MEM_INDICE]=$indice
			#Añadimos la salida por pantalla con COLOR
			memoriaSegunNecesidades[$ultimaPosicionMemoria,$MEM_TOSTRING]=${P_COLOR}$MEM_STRING_HUECO_VACIO${NC}
			

			if (( ultimaPosicionMemoria > tamMemoria)); then 
				breakpoint "Colega, tenemos un problemón en reubicarProcesos(), te has salido del array de memoria"
			fi
			(ultimaPosicionMemoria++)
		done
		
	done
	
}

ejecucion(){
	local -i procEjecutados=0
	local -i tiempoEjec=0

	local -i partLibres=$numeroParticiones
	local -i procesoCPUAnterior
	local  tEjecMedio=0
	local  tEsperaMedio=0
	local  tRetornoMedio=0
	local tEjecAcumulado=0
	local tEsperaAcumulado=0
	local tRetornoAcumulado=0
	local -i i
	local -i aux #auxiliar que indica la particion que se ha introducido un proceso
	local -i cambio #bool que se usa para ver cuando haya cambios en las particiones o cpu
	local -i bool #booleano para comprobar si se ha echado un proceso (apropiativo)
	#Empieza la ejecucion del programa

	#TODO: Inicializar el array de memoria
	#

	while [ $procEjecutados -lt $numProc ]; do # mientras el numero de procesos ejecutados sea menor a procesos total
		clear

		echo "Tiempo de ejecución: $tiempoEjec"

		#Introducimos a la cola los procesos que han llegado a memoria
		for((i=1;i<=numProc;i++)) do
			if [ "${procesos[$i,2]}" = $tiempoEjec ]; then
				anadirCola $i
			fi
		done		

		#comprobamos si alguno de los procesos que estan en memoria, han terminado
			#Si han terminado
			#Los sacamos
		#si no han terminado
		#continuamos


		#Si uno de los procesos con tLlegada == tEjecución
		#Y el proceso siguiente en la cola cabe
		#Ejecutamos la introduccion de un proceso en memoria

			#Ejecución de un proceso en memoria
			#Si hay un hueco los suficientemente grande como para introducir el proceso
				#Lo introducimos
			#si no hay
				#reubicamos



	done

	rm temp
	clear
	imprimirTabla 1 2 3 4 7 8
	informeTabla 1 2 3 7 8
	imprimirLCyan "Tiempo de ejecución medio: $BOLD$tEjecMedio"
	imprimirLCyan "Tiempo de espera medio: $BOLD$tEsperaMedio"
	imprimirLCyan "Tiempo de retorno medio: $BOLD$tRetornoMedio"
	escribirInforme "Tiempo de ejecución medio: $tEjecMedio"
	escribirInforme "Tiempo de espera medio: $tEsperaMedio"
	escribirInforme "Tiempo de retorno medio: $tRetornoMedio"
	
}

ejecucion2020(){
	clear

}

#funcionDeTesteo

#main
cargaDatos $opcionYN
escribeDatos
ordenarProcesos
inicializarArrays
clear
imprimirTabla 1 2 3 4 5
informeTabla 1 2 3 4 5


echo -e "
╔═══════════════════════════════════════╗
║					║
║${L_GREEN} Tamaño Partición: ${NC}${B_BLUE}$tamPart${NC}			║
║${L_GREEN} Número de Particiones: ${NC}${B_BLUE}$numeroParticiones${NC}		║
║${L_GREEN} Número de Procesos: ${NC}${B_BLUE}$numProc ${NC}		║
║${L_GREEN} Prioridad Mínima: ${NC}${B_BLUE}$priorMin${NC}			║
║${L_GREEN} Prioridad Máxima: ${NC}${B_BLUE}$priorMax${NC}			║
║${L_GREEN} Apropiativo: ${NC}${B_BLUE}$opcionApropiativo${NC}			║
║${L_GREEN} Estático: ${NC}${B_BLUE}$opcionEstatico${NC}				║
║					║
╚═══════════════════════════════════════╝"
escribirInforme "
╔═══════════════════════════════════════╗
║					║
║ Tamaño Partición: $tamPart			║
║ Número de Particiones: $numeroParticiones		║
║ Número de Procesos: $numProc 		║
║ Prioridad Mínima: $priorMin			║
║ Prioridad Máxima: $priorMax			║
║ Apropiativo: $opcionApropiativo			║
║ Estático: $opcionEstatico				║
║					║
╚═══════════════════════════════════════╝"
imprimirLCyan "Pulsa enter para continuar" -n
read -s
ejecucion

scanfSiNo "¿Quieres abrir el informe? [s/n]:" "abrirInforme"
if [ "$abrirInforme" = "s" ]; then
	more informePrioridadMenor.txt
fi

