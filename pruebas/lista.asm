#Prueba para ver si la lista sirve
#####################
#	Lee el nombre del archivo y lo guarda en una direcccion de memoria reservada 
#	dinamicamente
#
#####################
.data

pedir: .asciiz "ingrese el nombre del archivo: "
pedir2: .asciiz "Ingrese el contenido del archivo: "
.align 2
#Atributos de la lista
head: .word
tamaño: .word

#etiquetas utiles
nom: .space 20
buff: .space 1024

.text
#Cargamos el la direccion al head
la $s0, head
sw $s0, 0($s0)

main: 
	beq $s5, 3, finPrograma
	#imprimo nombre
	li $v0, 4
	la $a0, pedir
	syscall
		
	#leo nombre
	li $v0, 8
	la $a0, nom
	li $a1, 20
	syscall
	
	#imprimo cont
	li $v0, 4
	la $a0, pedir2
	syscall
		
	#leo cont
	li $v0, 8
	la $a0, buff
	li $a1, 256
	syscall
	
	#cargamos en $a0 nombre y $a1 contenido para añadir
	la $a0, nom
	la $a1, buff
	
	#Llamamos a la etiqueta añadir con los parametros $a0 = nom y $a1 = buff
	jal añadir

	#imprimimos el resultanto
	#primero el nombre
	lw $s0, head
	lw $a0, 0($s0)
	li $v0, 4
	syscall

	#imprimimos salto de linea
	li $v0, 11
	li $a0, 10
	syscall
	
	#imprimimos el contenido del espacio creado
	lw $a0, -4($s0)
	li $v0, 4
	syscall

	#imprimimos el tamaño del espacio creado
	lw $a0, -8($s0)
	li $v0, 1
	syscall

	#contador para terminar
	addi $s5, $s5, 1
	
	
	j main
	
reservarMemoria:
	#reservo memoria
	li $v0, 9
	li $a0, 20
	syscall
	
	#guardo la direccion de memoria
	move $t0, $v0 #aqui para poder guardarlo en memoria 
	move $s0, $v0 #aqui para tener la direccion efectiva 
	
	
	#guardamos el pointer de la direccion anterior
	addiu $sp, $sp, -8
	sw $ra, 4($sp)
	li $t3, 5
	#guardamos en $t1 la direccion de nombre
	la $t1, nom
	
	#Llamamos a la funcion para que guarde el nombre
	jal guardar
	
	#regresamos la direccion del stack a $ra
	lw $ra, 4($sp)
	addiu $sp, $sp, 8
	
	jr $ra
	
guardar: 
	#usamos $t3 para contar las veces
	lw $t2, 0($t1)
	sw $t2, 0($t0)
	
	#sumamos a las direcciones de memoria
	addi $t1, $t1, 4
	addi $t0, $t0, 4
	subi $t3, $t3, 1
	 
	bnez $t3, guardar 
	
	jr $ra

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
	#cargamos direccion del head en un registro
	la $t0, head
	
	#cargamos la direccion del nombre ingresado
	move $s0, $a0
	#cargamos la direccion del contenido ingresado
	move $s1, $a1
	
	#reservamos memoria con 20 bytes para crear el nuevo elemento de la lista
	li $v0, 9
	li $a0, 20
	syscall
	
	#guardamos en $t2 la direccion de espacio reservado
	move $t1, $v0
	
	#reservo memoria para el nombre del archivo
	li $v0, 9
	li $a0, 20
	syscall
	
	#guardamos en $t2 la direccion de espacio reservado para el contenido
	move $t2, $v0
	
	#pongo en el primer espacio del nodo la direccion del nombre
	sw $t2, 0($t1)
	
	#guardamos el contenido de la etiqueta nombre
	#usamos $s7 como contador
	li $s7, 5
	whileNombre: 
		#comprobamos si se termino el string
		beqz $s7, salidaNombre
		
		#cargamos la palabras de la etiqueta nombre
		lw $s6, 0($s0)
		#almacenamos la palabra en la direccion nombre
		sw $s6, 0($t2) 
		
		#sumamos 4 a $s0 y a $t2 y restamos 1 a $s7 
		addi $s0, $s0, 4
		addi $t2, $t2, 4
		subi $s7, $s7, 1
		
		#llamamos de nuevo a la etiqueta whileNombre
		j whileNombre
		
	salidaNombre:
		
	#reservamos memoria para el contenido del archivo
	li $v0, 9
	li $a0, 256
	syscall
	
	#guardamos en $t3 la direccion de espacio reservado para el contenido
	move $t3, $v0
	
	#pongo en el segundo espacio del nodo la direccion del contenido
	sw $t3, 0($t1)

	#guardamos el contenido de la etiqueta nombre
	#usamos $s7 como contador
	li $s7, 64
	whileCont: 
		#comprobamos si se termino el string
		beqz $s7, salidaCont
		
		#cargamos la palabras de la etiqueta nombre
		lw $s6, 0($s1)
		#almacenamos la palabra en la direccion nombre
		sw $s6, 0($t3) 
		
		#sumamos 4 a $s1 y a $t3 y restamos 1 a $s7 
		addi $s1, $s1, 4
		addi $t3, $t3, 4
		subi $s7, $s7, 1
		
		#llamamos de nuevo a la etiqueta whileNombre
		j whileCont
		
	salidaCont:
	
	#cargamos de nuevo la direccion de $a1 en $s1
	move $s1, $a1
	
	#contamos cuantos caracteres hay en el contenido para saber el tamaño del archivo
	# utilizamos $s6 para cargar bytes y $s7 para contador de bytes
	move $s7, $zero
	contarCaracteresCont:
		beqz  $s6, salirContarCaracteresCont
		
		#Cargamos el byte para luego verificar
		lb $s6, 0($s1)
		
		#sumamos 1 a $s1 para ver el siguiente byte y 1 a $s7 para contar
		addi $s1, $s1, 1
		addi $s7, $s7, 1
			
		j contarCaracteresCont
		
	salirContarCaracteresCont:
	
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
	sw $t1, 0($t0)
	
	#creo que ya esta listo...
	
	jr $ra
	
	
############################
#	Funcion para buscar un elemento en la lista dado el nombre del archivo
#	$a0 contiene el address del nombre del archivo a buscar
#	@return apuntador al nodo si esta, -1 si no esta
###########################
buscar:
	
	
	

remover:



finPrograma:
	
	li $v0, 10
	syscall

