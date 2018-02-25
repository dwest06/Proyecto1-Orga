#Prueba para ver si la lista sirve
#####################
#	Lee el nombre del archivo y lo guarda en una direcccion de memoria reservada 
#	dinamicamente
#
#####################
.data

pedir: .asciiz "ingrese el nombre del archivo: "
pedir2: .asciiz "Ingrese el contenido del archivo: "
esteNombre: .asciiz "Nombre: "
imprimirNombre: .asciiz "Nombre: "
esteContenido: .asciiz "Contenido: "
imprimirContenido: .asciiz "Contenido: "
esteTamaño: .asciiz "Tamaño: "
esteTamaño2: .asciiz " bytes"
imprimirHead: .asciiz "head: "
imprimirNodo: .asciiz "Nodo: "
imprimirCifrado: .asciiz "Cifrado: "
dirActual: .asciiz "direccion Actual: "

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
	beq $s5, 2, main2
	
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
	
	####################
	# Para debuguear
	####################
	li $v0, 4	#Imprimos head
	la $a0, imprimirHead
	syscall
	li $v0, 1	#imprimo antes del llamado la direccion que contiene head
	lw $a0, head
	syscall
	li $v0, 11	#salt de linea
	li $a0, 10
	syscall
	#####################
	
	jal añadir	#Llamamos a la etiqueta añadir con los parametros $a0 = nom y $a1 = buff

	#imprimimos el resultanto
	
	li  $v0, 4 	#primero el nombre
	la $a0, esteNombre
	syscall
	
	lw $s0, head	#Cargamos en $s0 el head de la lista
	lw $a0, 0($s0)	#cargamos la direccion 
	li $v0, 4
	syscall
	
	#imprimimos el contenido del espacio creado
	li  $v0, 4 
	la $a0, esteContenido
	syscall
	
	lw $a0, 4($s0)
	li $v0, 4
	syscall

	#imprimimos el tamaño del espacio creado
	li  $v0, 4 
	la $a0, esteTamaño
	syscall
	
	lw $a0, 8($s0)
	li $v0, 1
	syscall
	
	li  $v0, 4 
	la $a0, esteTamaño2
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
	la $a0, imprimirNodo
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
	#syscall	
	
	li $v0, 8	#leo nombre
	la $a0, nom
	li $a1, 20
	#syscall
	
	#guardamos en $a0 y $a1 el head y nombre
	lw $a0, head
	la $a1, nom
	
	#jal buscar
	
	move $t0, $a0
	
	#imprimo el contenido
	li $v0, 4
	lw $a0, 4($t0)
	#syscall
	
	j finPrograma
	
	
	
	
	

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
	
	####################
	# Para debuguear
	####################
	li $v0, 4	#Imprimos head pero con el contenido de t0
	la $a0, imprimirHead
	syscall
	li $v0, 1	#imprimo antes del llamado la direccion que contiene head
	move $a0, $t0
	syscall
	li $v0, 11	#salt de linea
	li $a0, 10
	syscall
	#####################
	
	
	
	li $v0, 9	#reservamos memoria con 20 bytes para crear el nuevo elemento de la lista
	li $a0, 20
	syscall
	
	move $t1, $v0	#guardamos en $t1 la direccion de espacio reservado
	
	####################
	# Para debuguear
	####################
	li $v0, 4	#Imprimos nodo
	la $a0, imprimirNodo
	syscall
	li $v0, 1	#imprimo nodo
	move $a0, $t1
	syscall
	li $v0, 11	#salt de linea
	li $a0, 10
	syscall
	#####################
	
	li $v0, 9	#reservo memoria para el nombre del archivo
	li $a0, 20
	syscall
	
	move $t2, $v0	#guardamos en $t2 la direccion de espacio reservado para el nombre
	
	####################
	# Para debuguear
	####################
	li $v0, 4	#Imprimos nodo
	la $a0, imprimirNombre
	syscall
	li $v0, 1	#imprimo nodo
	move $a0, $t2
	syscall
	li $v0, 11	#salt de linea
	li $a0, 10
	syscall
	#####################
	
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
	
	####################
	# Para debuguear
	####################
	li $v0, 4	#Imprimos nodo
	la $a0, imprimirContenido
	syscall
	li $v0, 1	#imprimo nodo
	move $a0, $t3
	syscall
	li $v0, 11	#salt de linea
	li $a0, 10
	syscall
	#####################
	
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
	####################
	# Para debuguear
	####################
	li $v0, 4	#Imprimos nodo
	la $a0, imprimirNodo
	syscall
	li $v0, 1	#imprimo nodo
	move $a0, $t0
	syscall
	li $v0, 11	#salt de linea
	li $a0, 10
	syscall
	#####################
	
	
	#asignamos nuevo head
	sw $t1, head
	
	####################
	# Para debuguear
	####################
	li $v0, 4	#Imprimos el contenido de $t1
	la $a0, imprimirNodo
	syscall
	li $v0, 1	#imprimo nodo
	move $a0, $t1
	syscall
	li $v0, 11	#salt de linea
	li $a0, 10
	syscall
	#####################
	
	####################
	# Para debuguear
	####################
	li $v0, 4	#Imprimos nodo
	la $a0, imprimirNodo
	syscall
	li $v0, 1	#imprimo nodo
	lw $a0, head
	syscall
	li $v0, 11	#salt de linea
	li $a0, 10
	syscall
	#####################
	
	#creo que ya esta listo...
	
	jr $ra
	
	
#####################################
#	Funcion para buscar un elemento en la lista dado el nombre del archivo
#	Nota: esta funcion esta modificada para que me retorne la direccion de memoria del nodo buscado y 
#	      lla direccion de memoria del nodo predecedor (nodo anterior al buscado)
#	Entrada:
#		$a0: contiene el apuntador al head
#		$a1: contiene el address del nombre del archivo a buscar
#	Registros usados
#		$t0: registro por el que nos movemos entre nodos
#		$t1: registro por el que nos movemos por los bytes de nombre
#		$s0: byte del nombre dado
#		$s1: byte del nombre guardado
#	Return:
#		$a0: apuntador al nodo si esta, -1 si no esta
#		$a1: apuntador al nodo anterior del encontrado
#####################################
###
### 	Me falta revisar est funcion e implementar el segundo return
###	El segundo return es guardar en $a1 la direccion del nodo anterior a que estoy buscando
###	esto con el fin de poder eliminar un nodo exitosamente y no tener que implementar un lista doblemente enlazada
###
#####################################

buscar:
	move $t0, $a0	#Colocamos en $t0 la direccion de memoria de contenida en el head
	
	move $t1, $a1	#Colocamos en $t1 la direccion de memoria del nombre del archivo
	
	#imprimos el contenido
	li $v0,1
	syscall
	
	li $v0, 11
	li $a0, 10
	syscall
	
	move $a0, $t0
	li $v0, 4
	syscall
	
	li $v0, 11
	li $a0, 10
	syscall
	
	li $v0,1
	move $a0, $a1
	syscall
	li $v0, 4
	syscall
	
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
		jr $ra	#Retorna y $a0 contiene el apuntador al nodo encontrado
	
	no:
		lw $a0, 16($t0)		#Cargamos la direccion del siguiente nodo
		beqz $a0, retornaMenosUno #Verificamos si en $a0 no esta el fin de los nodos
		j buscar
		
	retornaMenosUno:
		li $a0, -1 	#Cargamos en $a0, -1 el valor de retorno
		jr $ra		#retornamos -1 en $a0
		
#####################################
#	Funcion para eliminar un nodo de la estructura de datos
#	Entrada:
#		$a0: 
#		$a1: 
#	Registros usados
#		$t0: 
#		$t1: 
#		$s0: 
#		$s1: 
#	Return:
#		$a0: 
#####################################
remover:



finPrograma:
	
	li $v0, 10
	syscall
