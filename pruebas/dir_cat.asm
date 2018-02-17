#Prueba de implementacion del metodo cat

#####
# NO ME RECONOCE EL NOMBRE DEL ARCHIVO CUANDO SE PIDE AL USUARIO
####
.data
nombre: .asciiz "texto.txt"

#para leer archivos hay que tener los archivos en la misma carpeta donde se encuentra Mars
buffer: .space 1024

.text

main:
	#pedir al usuario el nombre del archivo
	#la $a0, nombre
	#li $a1, 40
	#li $v0 , 8
	#syscall
	
	#abrir el archivo
	la $a0, nombre
	li $a1, 0
	li $a2, 0
	li $v0,13 # aqui se guarda el file descriptor
	syscall
 	
	#leer el archivo
	move $a0, $v0
	la $a1, buffer
	li $a2, 100
	li $v0, 14 # aqui se guarda el numero de caracteres leidos
	syscall
	
	#imprimir 
	la $a0, buffer
	li $v0, 4
	syscall
	
	#terminar el programa
	li $v0, 10
	syscall
	
