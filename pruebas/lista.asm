#Prueba para ver si la lista sirve

.data
#Atributos de la lista
pedir: .asciiz "ingrese el nombre del archivo"
	.align 2
	
inicio: .word
fin: .word
tamaño: .word

#etiquetas utiles
nombre: .space 20
buff: .space 1024

.text
main: 
	#imprimo
	li $v0, 4
	la $a0, hola
	syscall
	
	#leo texto
	li $v0, 8
	la $a0, nom
	li $a1, 20
	syscall
	
	#reservar memoria
	jal reservarMemoria
	
	#imprimimos la direccion de memoria 
	li $v0, 1
	move $a0, $s0
	syscall
	
	#imprimimos salto de linea
	li $v0, 4
	la $a0, salto
	syscall
	
	#imprimimos el contenido del espacio creado
	li $v0, 4
	move $a0, $s0
	syscall
	
	addi $s7, $s7, 1
	
	bne $s7, 3, main
	
	j finPrograma
	
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

finPrograma:
	
	li $v0, 10
	syscall
