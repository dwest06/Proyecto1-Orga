#Prueba para ver si la lista sirve
#####################
#	Lee el nombre del archivo y lo guarda en una direcccion de memoria reservada 
#	dinamicamente
#
#####################
.data

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

.align 2

#Atributos de la lista
head: .space 4
#tamaño: .word

#etiquetas utiles
nom: .space 20
buff: .space 1024


.text
init:
	sw $zero, head	#almacenamos en head 
	
interprete:


main: 
	beq $s5, 5, main2
	
	li $v0, 4	#imprimo nombre
	la $a0, pedir
	syscall	
	
	li $v0, 8	#leo nombre
	la $a0, nom
	li $a1, 20
	syscall
	
	li $v0, 4	#imprimo cont
	la $a0, pedir2
	syscall
		
	li $v0, 8	#leo cont
	la $a0, buff
	li $a1, 256
	syscall
		
	la $a0, nom	#cargamos en $a0 nombre y $a1 contenido para añadir
	la $a1, buff
	
	jal añadir	#Llamamos a la etiqueta añadir con los parametros $a0 = nom y $a1 = buff

	#imprimimos el resultanto
	
	li  $v0, 4 	#primero el nombre
	la $a0, imprimirNombre
	syscall
	
	lw $s0, head	#Cargamos en $s0 el head de la lista
	lw $a0, 0($s0)	#cargamos la direccion 
	li $v0, 4
	syscall
	
	#imprimimos el contenido del espacio creado
	li  $v0, 4 
	la $a0, imprimirContenido
	syscall
	
	lw $a0, 4($s0)
	li $v0, 4
	syscall

	#imprimimos el tamaño del espacio creado
	li  $v0, 4 
	la $a0, imprimirTamaño
	syscall
	
	lw $a0, 8($s0)
	li $v0, 1
	syscall
	
	li  $v0, 4 
	la $a0, imprimirTamaño2
	syscall
	
	#imprimimos salto de linea
	li $v0, 11
	li $a0, 10
	syscall
	
	#Imprimimos el cifrado
	li $v0, 4
	la $a0, imprimirCifrado
	syscall
	
	li $v0, 1
	lw $a0, 12($s0)
	syscall
	
	li $v0, 11
	li $a0, 10
	syscall
	
	#imprimimos direccion del nodo siguiente
	
	li $v0, 4
	la $a0, imprimirNodoSiguiente
	syscall
	
	li $v0, 1
	lw $a0, 16($s0)
	syscall
	
	li $v0, 11
	li $a0, 10
	syscall

	#contador para terminar
	addi $s5, $s5, 1
	
	j main

#Buscamos	

main2:
	li $v0, 4	#imprimo nombre
	la $a0, pedir
	syscall	
	
	li $v0, 8	#leo nombre
	la $a0, nom
	li $a1, 20
	syscall
	
	jal buscar #Llamamos a la funcion buscar
	
	blez $a0, error
	
	
	move $t2, $a0	# guardo el nodo encontrado
	move $t3, $a1	#guardo el nodo anteriro (util para eliminar)
	
	li $v0, 11
	li $a0, 10
	syscall
	
	li $v0, 1
	move $a0, $t2
	syscall
	
	li $v0, 11
	li $a0, 10
	syscall
	
	li $v0, 1
	move $a0, $t3
	syscall
	li $v0, 11
	li $a0, 10
	syscall
	
	lw $t0, 4($t2) #Guardamos en $t0 lo retornado en $a0, la direccion de memoria del nodo
	li $v0, 4
	move $a0, $t0
	syscall
	
	lw $t0, 4($t3) #Guardamos en $t0 lo retornado en $a0, la direccion de memoria del nodo
	li $v0, 4
	move $a0, $t0
	syscall
	
main3:
	li $v0, 4	#imprimo nombre
	la $a0, pedir
	syscall	
	
	li $v0, 8	#leo nombre
	la $a0, nom
	li $a1, 20
	syscall
	
	#Eliminamos el archivo pedido
	jal remover
	
	jal dir_ls
	
	j finPrograma
	
	
#####################################
#	Funcion para buscar un elemento en la lista dado el nombre del archivo
#	Nota: esta funcion esta modificada para que me retorne la direccion de memoria del nodo buscado y 
#	      lla direccion de memoria del nodo predecedor (nodo anterior al buscado)
#	Entrada:
#
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
	la $t1, nom	#Colocamos en $t1 la direccion de memoria del nombre del archivo
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
	
	la $s0, nom	#cargamos la direccion del nombre ingresado
	
	la $s1, buff 	#cargamos la direccion del contenido ingresado
	
	
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
	li $s7, 5	#usamos $s7 como contador
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
	
	blez $a0, error	#verificamos si el nodo existe en la lista
	
	lw $t0, 16($a0)	#Cargamos el siguiente nodo
	
	move $a0, $t0
	li $v0, 1
	syscall
	
	sw $t0, 16($a1)	#sobreescribimos el nodo actual por el siguiente
	
	jr $ra
	

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
	
		#imprimimos salto de linea
		li $v0, 11
		li $a0, 10
		syscall
		
		#imprimimos el contenido del espacio creado
		li  $v0, 4 
		la $a0, imprimirContenido
		syscall
		
		lw $a0, 4($s5)
		li $v0, 4
		syscall	
		#imprimimos salto de linea
		li $v0, 11
		li $a0, 10
		syscall
	
		#imprimimos el tamaño del espacio creado
		li  $v0, 4 
		la $a0, imprimirTamaño
		syscall
		
		lw $a0, 8($s5)
		li $v0, 1
		syscall
		
		li  $v0, 4 
		la $a0, imprimirTamaño2
		syscall
		
		#imprimimos salto de linea
		li $v0, 11
		li $a0, 10
		syscall
		
		#Imprimimos el cifrado
		li $v0, 4
		la $a0, imprimirCifrado
		syscall
		
		li $v0, 1
		lw $a0, 12($s5)
		syscall
		
		li $v0, 11
		li $a0, 10
		syscall
		
		#imprimimos direccion del nodo siguiente
		
		li $v0, 4
		la $a0, imprimirNodoSiguiente
		syscall
		
		li $v0, 1
		lw $a0, 16($s5)
		syscall
		
		move $s5, $a0
		
		li $v0, 11
		li $a0, 10
		syscall
		
		j repetirLs
	finLs:
		jr $ra
		

error:
	li $v0, 4
	la $a0, imprimirError
	syscall

finPrograma:
	
	li $v0, 10
	syscall
