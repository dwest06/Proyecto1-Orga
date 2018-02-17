#Prueba implementacion del metodo cp
.data
nombre1: .asciiz "texto.txt"
nombre2: .asciiz "texto2.txt"

buffer: .space 1024

.text

	#abrimos el archivo 1 para ver su contenido
	li $v0, 13 # aqui se guarda el file descriptor
	la $a0, nombre1
	li $a1, 0 #llamamos al flag 0 para poder usarlo de lectura
	li $a2, 0
	syscall
	
	#guardamos el file descriptor
	move $t0, $v0
	
	#guardamos el contenido del archivo en una etiqueta
	li $v0, 14 #aqui se guarda el numero de caracteres leidos
	move $a0, $t0
	la $a1, buffer
	li $a2, 256
	syscall
	
	#guardamos el numero de caracteres leidos
	move $t1, $v0
	
	#ver que agarro
	li $v0, 4
	la $a0, buffer
	syscall
	
	#abrimos el segundo 
	li $v0, 13
	la $a0, nombre2
	li $a1, 1 #llamamos con e flag 1 para poder sobreescribir
	li $a2, 0
	syscall
	
	#guardamos el segundo file descriptor
	move $t2, $v0
	
	#cerrar el archivo
	li $v0, 16
	move $a0, $t1
	syscall
	
	#sobreescribimos el segundo archivo
	li $v0, 15
	move $a0,$t2
	la $a1, buffer
	move $a2, $t1
	syscall
	
	#cerrar el archivo
	li $v0, 16
	move $a0, $t2
	syscall
	
	#terminar programa
	li $v0, 10
	syscall