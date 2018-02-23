.data

nombre: .asciiz "hola lio wao si has cabiao"
salto: .asciiz "\n"
l: .ascii "w"

.text

main:
	#cargamos l direccion de nombre
	la $t0, nombre
	#inicializamos en 0
	move $s0, $zero
	#cargamos la direcion de l
	la $s1, l
	#cargamos el primer byte
	lb $t2, 0($s1)
	
loop:
	#cargamos el caracter
	lb $t1, 0($t0)
	
	#sumamos 1 para obtener la sigiente posicion del string
	addi $t0, $t0, 1
	
	#sumamos 1 para saber el tamaño del string
	addi $s0, $s0, 1
	
	#verificamos si el caracter agarrado es el que cumple
	bnez $t1, loop
	
	subi $s0,$s0,1
	
	#imprime el numero de caracteres
	li $v0,1
	move $a0, $s0
	syscall
	
	
finloop:
	li $v0, 10
	syscall
	
	
	
	
	
	
	

