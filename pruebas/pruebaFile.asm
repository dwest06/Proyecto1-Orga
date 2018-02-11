.data
text: .asciiz "/home/david/guias usb/mips/Proyecto1-Orga/pruebas/texto.txt"
buffer: .space 1024
salto: .asciiz "\n"

.text

main:
	#pido texto al usuario
	#li $v0, 8
	la $a0, text
	#li $a1, 20
	#syscall
	
	#imprime text
	li $v0, 4
	syscall
	
	#open file
	li $v0, 13
	la $a0, text
	li $a1, 0
	li $a2, 0
	syscall
	move $t0, $v0
	
	#imprime el file descriptor
	li $v0,1
	move $a0,$t0
	syscall
	
	li $v0,4

	
	#read File
	move $a0, $t0
	li $v0, 14
	la $a1,buffer
	li $a2, 100
	syscall
	
	#salto de linea
	li $v0,4	
	la $a0,salto
	syscall
	
	#imprime lo que esta en el buffer
	la $a0, buffer
	syscall
	
	
	
	
	li $v0, 10
	syscall
	
