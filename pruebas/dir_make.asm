.data
nombre: .space 20
buffer: .space 100

salto: .asciiz "\n"

.text

	#pedimos el nombre y el contenido al usuario
	li $v0, 8
	la $a0, nombre
	li $a1, 20
	syscall
	
	la $a0, buffer
	li $a1, 100
	syscall
	
	#Arreglar la entrada
	la $a0,nombre
	jal arreglarInput
	
	
	#Creamos el archivo
	li $v0, 13
	la $a0, nombre
	li $a1, 1
	li $a2, 0
	syscall
	
	#guardamos el file descriptor
	move $t0, $v0
	
	#añadimos el contenido al archivo
	li $v0, 15
	move $a0, $t0
	la $a1, buffer
	li $a2, 1024
	syscall
	
	#Finalizamos el programa
	li $v0, 10
	syscall

##################
#Entrada : 
#	$a0: nombre del archivo
##################
arreglarInput:
	move $t0,$a0
	
####################
#Entrada : 
#	$a0: string de caracteres a contar

contarCaracteres