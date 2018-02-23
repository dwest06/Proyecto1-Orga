### Metodo init
## Leer el archivo init, 
##
##


.data

nombre: .asciiz "init.txt" 
buffer: .space 1024
salto: .asciiz "\n"

nom: .align 2
.space 20
buff: .align 2
.space 256

.text

main:
	#Usaremos el registro $t7 para ir contando el numero de caracteres
	
	
	#abrimos el archivo init solo para lectura
	li $v0, 13
	la $a0, nombre
	li $a1, 0
	li $a2, 0
	syscall
	
	#Leemos el contenido del archivo
	move $a0, $v0
	li $v0, 14
	la $a1, buffer
	li $a2, 256
	syscall

primeraLinea:		
	#Primera linea: numero de archivo a crear
	#buscamos cuantos archivos vamos a leer
	la $s0, buffer
	#en $t0 se guarda el caracter del numero
	lb $t0, 0($s0)
	#lo convertimos a entero
	subi $t0, $t0, 48
	
	#imprimimos el entero
	move $a0, $t0
	li $v0, 1
	syscall
	#guardo la cantidad de archivos del init
	move $s7, $t0
	
	#Seguientes lineas
	#sumamos 2 bytes a $s0 para ir a la siguiente linea
	addi $s0, $s0, 2

SiguientesLineas:
	
	
	#cargamos el primer byte del salto de linea
	la $t0, salto
	lb $t1, 0($t0) # \n
	lb $t0, 0($s0) # a
	la $t2, nom
	#cargamos el primer byte
	
	#imprimimos los bytes cargados
	li $v0, 11
	move $a0, $t0
	syscall
	
	###########
	#Llamamos a la funcion leerNombre para obtener el nombre del archivo
	###########
	jal leerNombre
	
	#leer el numero de lineas, que no son mas que las apariciones de los \n
	#en $t0 se guarda el caracter del numero
	lb $t0, 0($s0)
	#lo convertimos a entero
	subi $t0, $t0, 48
	#imprimimos el entero
	move $a0, $t0
	li $v0, 1
	syscall
	
	###########
	#Llamamos a la funcion leerBuff para obtener el contenido del archivo
	###########
	la $t0, salto
	lb $t1, 0($t0)
	lb $t0, 0($s0)
	la $t2, buff
	
	#Llamamos a la funcion
	#jal leerBuff
	
	#llamo a dir_make para crear el archivo
	
	#añadirlo a la lista
	
	#subi $s7, $s7, 1
	#bnez $s7, siguientesLineas
	
	
	#Fin del Programa
	li $v0, 10
	syscall
	
#################################
# Leo y creo cada archivo que me piden
# $s0 direccion del contenido del archivo
# $t1 caracter de sato de linea
# $t2 direccion del nombre
################################
leerNombre:
	#almacenamos el byte en la etiqueta nombre
	sb $t0, 0($t2)
		
	#sumamos y cargamos el byte para verficiar con el branch
	addi $t2, $t2, 1
	addi $s0, $s0, 1
	lb $t0, 0($s0)
	
	#imprimimos los bytes cargados
	li $v0, 11
	move $a0, $t0
	syscall

	bne $t0, $t1, leerNombre
	
	#sumamos uno mas para evitar el salto de linea y de una caer en el siguiente caracter
	addi $s0, $s0, 1
	
	#regresamos a la etiqueta anterior
	jr $ra
	
###################################
# leo el contenido del archivo
# $s0 direccion del archivo
# $t1 caracter salto de linea
# $t2 direccion de memoria del buff
###################################

leerBuff:
	#almacenamos el byte en la etiqueta nombre
	sb $t0, 0($t2)
		
	#sumamos y cargamos el byte para verficiar con el branch
	addi $t2, $t2, 1
	addi $s0, $s0, 1
	lb $t0, 0($s0)
	
	#imprimimos los bytes cargados
	li $v0, 11
	move $a0, $t0
	syscall
	
	##############
	#### HACE FALTA HACER OTRA FUNCION PARA RECONOCER SI EL CARACTER ES UN
	#### SALTO DE LINEA Y LAS APARICIONES DEL MISMO
	##############
	
	beq $t0, $t1, leerNombre
	
	#sumamos uno mas para evitar el salto de linea y de una caer en el siguiente caracter
	addi $s0, $s0, 1
	
	#regresamos a la etiqueta anterior
	jr $ra
