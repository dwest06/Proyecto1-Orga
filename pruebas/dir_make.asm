.data
nombre: .asciiz "Bad_Bunny.txt"

buffer: .asciiz "Canciones de Bad Bunny:\n* Vuelve\n* Bailame(remix)\n* Chambea"

.text

	#pedimos el nombre y el contenido al usuario
	
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
	