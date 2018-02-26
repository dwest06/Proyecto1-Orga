############################
#	Proyecto 1 | Organizacion del computador
#	Implementacion de un directorio con su interprete de comandos usando una lista simplemtente enlazada
############################
.data

#Etiquetas para interactuar con el usuario

pedir: .asciiz "ingrese el nombre del archivo: "
pedir2: .asciiz "Ingrese el contenido del archivo: "
imprimirNombre: .asciiz "Nombre: "
imprimirContenido: .asciiz "Contenido: "
imprimirTamaño: .asciiz "Tamaño: "
imprimirTamaño2: .asciiz " bytes"
imprimirHead: .asciiz "head: "
imprimirNodo: .asciiz "Nodo: "
imprimirNodoSiguiente: .asciiz "Nodo siguiente: "
imprimirCifrado: .asciiz "Cifrado: "
dirActual: .asciiz "direccion Actual: "
imprimirError: .asciiz "Ha ocurrido un error."
init: .asciiz "init.txt"
a: .asciiz "otro.txt"

#Alineamos las sigueintes etiquetas
.align 2

#Atributos de la lista
head: .space 4
#tamaño: .space 4

#Etiquetas para guardar informacion obtenida del usuario
nom: .space 20
buff: .space 1024
buff2: .space 1024
.text

####################
#	Cargamos el archivo init.txt para inicializar el directorio
#####################
cargarInit:
	#Usaremos el registro $t7 para ir contando el numero de caracteres
	
	li $v0, 13	#abrimos el archivo init solo para lectura
	la $a0, init
	li $a1, 0
	li $a2, 0
	syscall
	
	move $a0, $v0	#Leemos el contenido del archivo
	li $v0, 14
	la $a1, buff2
	li $a2, 256
	syscall

	primeraLinea:	#Primera linea: numero de archivo a crear
		la $s0, buff2	#buscamos cuantos archivos vamos a leer
		
		lb $t0, 0($s0)	#en $t0 se guarda el caracter del numero
		
		subi $t0, $t0, 48	#lo convertimos a entero
		
		move $s7, $t0	#guardo la cantidad de archivos del init
		
		#Seguientes lineas
		addi $s0, $s0, 2	#sumamos 2 bytes a $s0 para ir a la siguiente linea
		
	siguienteLinea:
		beqz $s7, main	#Salimos de leer cuando $s7 sea 0
		
		#Cargamos en el registro $t0 la direccion del nombre 
		la $s1, nom	#Cargamos en $s1 la direccion donde queremos almacernar el nombre
		lb $t1, 0($s0)	#cargamos el primer byte del contenido del archivo
		leerNombreInit:
			beq $t1,10, salirLeerInit
			
			sb $t1, 0($s1)	#almacenamos en el byte cargado en la etiqueta nombre
			addi $s0, $s0, 1 #Sumamos uno para ir al siguiente byte
			addi $s1, $s1, 1
			lb $t1, 0($s0)	#cargamos el siguiente byte del init
			
			j leerNombreInit
			
		salirLeerInit:
			addi $s0, $s0, 1	#Sumamos 1 al para evitar el salto de linea
		
		#Leemos el siguiente numero que nos indica el numero de lineas de que contiene el archivo
		lb $t0, 0($s0)	#en $t0 se guarda el caracter del numero
		
		subi $t0, $t0, 48	#lo convertimos a entero
		
		move $s6, $t0	#guardo la cantidad de archivos del init
		
		#Seguientes lineas
		addi $s0, $s0, 2	#sumamos 2 bytes a $s0 para ir a la siguiente linea
		
		#Cargamos en el registro $t0 la direccion del nombre 
		la $s1, buff	#Cargamos en $s1 la direccion donde queremos almacernar el nombre
		lb $t1, 0($s0)	#cargamos el primer byte del contenido del archivo
		leerContenidoInit:
			bne $t1, 10, saltoInit	#Cuando encuentre un salto de linea, resta 1 al contador
				subi $s6, $s6, 1	#resto 1 al contador
			
			saltoInit:
			
			beqz $s6, finLeerContenidoInit	#Cuando $s6 llegue a zero
			
			sb $t1, 0($s1)	#almacenamos en el byte cargado en la etiqueta nombre
			addi $s0, $s0, 1 #Sumamos uno para ir al siguiente byte
			addi $s1, $s1, 1
			lb $t1, 0($s0)	#cargamos el siguiente byte del init
			
			j leerContenidoInit
			
			
		finLeerContenidoInit:
		
		#guardamos el contenido de $s0 y $7 en la pila
		subi $sp, $sp, 8
		sw $s0, 0($sp)
		sw $s7, 4($sp)
		
		#Añadirmos el nuvo elemento a la lista llamando a la funcion añadir
		jal añadir
		
		#retornamos los valores de $s0 y $s7
		lw $s7, 4($sp)
		lw $s0, 0($sp)
		addi $sp, $sp, 8

		addi $s0, $s0, 1
		subi $s7, $s7, 1
		
		j siguienteLinea
	


#####################################
#	Metodo principal donde esta el interprete de comandos
#	Registros usados:
#		$t0: Head de la lista
#		$t1: Direccion del nuevo nodo a crear
#		$t2: Direccion donde se guardara el nombre
#		$t3: Direccion donde se guardara el contenido
#		$s0: Direccion de la eqtiqueta nombre
#		$s1: Direccion de la etiqueta contenido
#		$s6: Bytes para contar
#		$s7: contador
######################################			
main:
	#probamos buscar
	
	la $a0, a
	
	jal buscar
	
	move $t0, $a0
	move $t1, $a1
	
	lw $t2, 4($t0)
	
	move $a0, $t2
	li $v0, 4
	syscall
	
	#probamos ls
	
	#jal dir_ls
	
	j fin
	
#####################################
#	Metodo para añadir un nuevo elemento a la lista
#	Entrada: 
#		$a0: Nombre del archivo a ingresar
#		$a1: Contenido del archivo a ingresar
#	Registros usados:
#		$t0: Head de la lista
#		$t1: Direccion del nuevo nodo a crear
#		$t2: Direccion donde se guardara el nombre
#		$t3: Direccion donde se guardara el contenido
#		$s0: Direccion de la eqtiqueta nombre
#		$s1: Direccion de la etiqueta contenido
#		$s6: Bytes para contar
#		$s7: contador
#	Return:
#		$a0: 1 si se agregó el nodo, -1 si no
######################################
añadir:
	
	lw $t0, head	#cargamos direccion del head en un registro
	
	move $s0, $a0	#cargamos la direccion del nombre ingresado
	
	move $s1, $a1 	#cargamos la direccion del contenido ingresado
	
	
	li $v0, 9	#reservamos memoria con 20 bytes para crear el nuevo elemento de la lista
	li $a0, 20
	syscall
	
	move $t1, $v0	#guardamos en $t1 la direccion de espacio reservado
	
	li $v0, 9	#reservo memoria para el nombre del archivo
	li $a0, 20
	syscall
	
	move $t2, $v0	#guardamos en $t2 la direccion de espacio reservado para el nombre
	
	sw $t2, 0($t1)	#pongo en el primer espacio del nodo la direccion del nombre
	
	#guardamos el contenido de la etiqueta nombre
	li $s7, 5	#usamos $s7 como contador
	whileNombre: 
		beqz $s7, salidaNombre	#comprobamos si se termino el string
		
		lw $s6, 0($s0)		#cargamos la palabras de la etiqueta nombre
		sw $s6, 0($t2)		#almacenamos la palabra en la direccion nombre
		
		addi $s0, $s0, 4	#sumamos 4 a $s0 y a $t2 y restamos 1 a $s7 
		addi $t2, $t2, 4
		subi $s7, $s7, 1
		
		j whileNombre		#llamamos de nuevo a la etiqueta whileNombre
		
	salidaNombre:
		
	
	li $v0, 9	#reservamos memoria para el contenido del archivo
	li $a0, 256
	syscall
	
	move $t3, $v0	#guardamos en $t3 la direccion de espacio reservado para el contenido
	
	sw $t3, 4($t1)	#pongo en el segundo espacio del nodo la direccion del contenido

	#guardamos el contenido de la etiqueta nombre
	li $s7, 64	#usamos $s7 como contador
	whileCont: 
		beqz $s7, salidaCont	#comprobamos si se termino el string
		
		lw $s6, 0($s1)		#cargamos la palabras de la etiqueta nombre
		sw $s6, 0($t3) 		#almacenamos la palabra en la direccion nombre
		
		addi $s1, $s1, 4	#sumamos 4 a $s1 y a $t3 y restamos 1 a $s7 
		addi $t3, $t3, 4
		subi $s7, $s7, 1
		
		j whileCont		#llamamos de nuevo a la etiqueta whileNombre
		
	salidaCont:
	
	la $s1, buff	#cargamos de nuevo la direccion de $a1 en $s1
	
	#contamos cuantos caracteres hay en el contenido para saber el tamaño del archivo
	move $s7, $zero		# utilizamos $s6 para cargar bytes y $s7 para contador de bytes
	lb $s6, 0($s1)
	contarCaracteresCont:
		beqz  $s6, salirContarCaracteresCont
		
		addi $s1, $s1, 1	#sumamos 1 a $s1 para ver el siguiente byte y 1 a $s7 para contar
		addi $s7, $s7, 1
		
		lb $s6, 0($s1)	#Cargamos el byte para luego verificar
			
		j contarCaracteresCont
		
	salirContarCaracteresCont:
		subi $s7, $s7, 1	#Restamos 1 al contador para que de el resultado exacto
	
	#almaceno en el tercer puesto del nodo el tamaño obtenido en $s7
	sw $s7, 8($t1)
	
	##########
	#Por lo momentos se asumira que se añaden archivos no cifrados
	##########
	
	#colocamos como no cifrado el nuevo archivo
	sw $zero, 12($t1)
	
	#colocamos el apuntador al nodo anterior
	sw $t0, 16($t1)
	
	
	#asignamos nuevo head
	sw $t1, head
	
	jr $ra

#####################################
#	Funcion para buscar un elemento en la lista dado el nombre del archivo
#	Nota: esta funcion esta modificada para que me retorne la direccion de memoria del nodo buscado y 
#	      lla direccion de memoria del nodo predecedor (nodo anterior al buscado)
#	Entrada:
#		$a0: direccion del nombre a buscar
#	Registros usados
#		$t0: registro por el que nos movemos entre nodos
#		$t1: registro por el que nos movemos por los bytes de nombre
#		$s0: byte del nombre dado
#		$s1: byte del nombre guardado
#	Return:
#		$a0: apuntador al nodo si esta, -1 si no esta
#		$a1: apuntador al nodo anterior del encontrado
#####################################

buscar:
	lw $t2, head	#Colocamos en $t0 la direccion de memoria de contenida en el head
	move $t1, $a0	#Colocamos en $t1 la direccion de memoria del nombre del archivo
	lw $a1, head	#Iniciaizamos $a0 con el inicio del head
	
buscarInterno:
	lw $t0, 0($t2)
	#Ahora comparamos byte por byte, el nombre
	lb $s0, 0($t0)	#cargamos el primer byte del nombre dado
	lb $s1, 0($t1)	#cargamos el primer byte del nombre guardado
	comparar: 
		bne $s0, $s1, no	#saltamos a no si $s0 y $s1 son distintos
		beqz $s0, si		#saltamos a si, si $s0 es nulo
		
		addi $t0, $t0, 1	#sumamos 1 a $t0
		addi $t1, $t1, 1	#sumamos 1 a $t1
		
		lb $s0, 0($t0)		#cargamos el primer byte del nombre dado
		lb $s1, 0($t1)		#cargamos el primer byte del nombre guardado
	
		j comparar
	si:	
		move $a0, $t2
		jr $ra	#Retorna y $a0 contiene el apuntador al nodo encontrado
	
	no:
		move $a1, $t2
		lw $t0, 16($t2)		#Cargamos la direccion del siguiente nodo
		move $t2, $t0
		beqz $t2, retornaMenosUno #Verificamos si en $a0 no esta el fin de los nodos
		j buscarInterno
		
	retornaMenosUno:
		li $a0, -1 	#Cargamos en $a0, -1 el valor de retorno
		jr $ra		#retornamos -1 en $a0

#####################################
#	Funcion para eliminar un nodo de la estructura de datos
#	Entrada:
#		$a0: nombre del archivo
#	Registros usados
#		$t0: 
#		$t1: 
#		$s0: 
#		$s1: 
#	Return:
#		$a0: 1 si se eliminó, -1 si no
#####################################
remover:
	move $t0, $a0	#guardamos en $t0 el nombre
	
	#guardamos el contenido de $s0 y $7 en la pila
	subi $sp, $sp, 4
	sw $ra, 0($sp)
	
	#buscamos el elemento
	
	jal buscar
	
	#retornamos los valores de $s0 y $s7
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	#blez $a0, error	#verificamos si el nodo existe en la lista
	
	lw $t0, 16($a0)	#Cargamos el siguiente nodo
	
	
	sw $t0, 16($a1)	#sobreescribimos el nodo actual por el siguiente
	
	jr $ra
#########################################################
#########################################################
###	COMANDOS DEL INTEPRETADOR
#########################################################
#########################################################

dir_make:
	#en $a0 y $a1 estan las direcciones del nombre y buff
	#guardamos el contenido en la pila
	subi $sp, $sp, 4
	sw $ra, 0($sp)
	
	#Eliminamos el elemento
	
	jal añadir
	
	#retornamos los valores de la pila
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra
	

	
dir_rm:
	#guardamos el contenido en $a0, el nombre ya deberia estar guardado en $a0
	
	#guardamos el contenido en la pila
	subi $sp, $sp, 4
	sw $ra, 0($sp)
	
	#Eliminamos el elemento
	
	jal remove
	
	#retornamos los valores de la pila
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	
	jr $ra

dir_ren:
	

		
dir_ls:
	lw $s5, head
	repetirLs:
		beqz $s5, finLs
		
		#imprimimos el resultanto
		li  $v0, 4 	#primero el nombre
		la $a0, imprimirNombre
		syscall
		
		lw $a0, 0($s5)	#cargamos la direccion 
		li $v0, 4
		syscall
	
		li $v0, 11	#imprimimos salto de linea
		li $a0, 10
		syscall
		
		
		li  $v0, 4 	#imprimimos el contenido del espacio creado
		la $a0, imprimirContenido
		syscall
		
		lw $a0, 4($s5)	#Contenido
		li $v0, 4
		syscall	
		
		li $v0, 11	#imprimimos salto de linea
		li $a0, 10
		syscall
	
		li  $v0, 4 	#imprimimos el tamaño del espacio creado
		la $a0, imprimirTamaño
		syscall
		
		lw $a0, 8($s5)	#imprimimos el tamaño del archivo
		li $v0, 1
		syscall
		
		li  $v0, 4 	#Imprimimos "bytes"
		la $a0, imprimirTamaño2
		syscall
		
		li $v0, 11	#imprimimos salto de linea
		li $a0, 10
		syscall
		
		#Imprimimos el cifrado
		li $v0, 4	#etiquetad cifrado
		la $a0, imprimirCifrado
		syscall
		
		li $v0, 1	#cifrado
		lw $a0, 12($s5)
		syscall
		
		li $v0, 11	#salto de linea
		li $a0, 10
		syscall
		
		#imprimimos direccion del nodo siguiente
		
		li $v0, 4	#Etiqueta del siguiente nodo
		la $a0, imprimirNodoSiguiente
		syscall
		
		li $v0, 1	#imprimos el sigueinte nodo
		lw $a0, 16($s5)
		syscall
		
		move $s5, $a0	#Cargamos en $s5 el sigueinte nodo
		
		li $v0, 11	#salto de linea
		li $a0, 10
		syscall
		
		j repetirLs
	finLs:
		jr $ra

		
dir_cat:
	#buscamos el archivo contenido en $a0
	#guardamos el contenido en la pila
	subi $sp, $sp, 4
	sw $ra, 0($sp)
	
	#Eliminamos el elemento
	
	jal buscar
	
	#retornamos los valores de la pila
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	move $t0, $a0
	
	lw $a0, 4($t0)
	li $v0, 4
	syscall	
	
	jr $ra			

error: 
	li $v0, 4
	la $a0, imprimirError
	syscall
fin:
	li $v0, 10
	syscall
