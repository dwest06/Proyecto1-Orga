# Proyecto1-Orga
Primer proyecto de la materia Organizacion del Computador CI-3815 Ene-Mar 2018


## Clase Directorio

### Archivos guardados (ideas)

* Se usa el file descriptor de cada archivo para guardarlos en un arreglo

* Se usara un arreglo multidimensional (2 dimensiones. Aprox Nx3) para guardar el file descriptor(posicion 0), el tamaño del archivo (posicion 1) y si esta cifrado o no ( posicion 2)

| Nombre | Tamaño | Cifrado |
|--------|:------:|--------:|
|0x6158  |  64kb  |    1    |
|0x4625  |  32kb  |    0    |

### Funcion rm (remove)

* borrar la informacion del arreglo en la estructura de datos (arreglo).

* ¿Hara falta reordenar? como usaremos el file descriptor creo que no.

### Funcion ren (renombrar el archivo)

* Hacemos un nuevo archivo con make, luego rm para eliminar el que no nos interesa

### Funcion ls 

* Mostrar por pantalla todo el contenido de la estructura de datos.

### Funcion cif y dcif (cifrar y decifrar)

* Se abre el archivo, se extrae el contenido y se pasa por la funcion de cifrado, luego se sobreescribe el archivo o se crea uno nuevo (?).

* Se usa el metodo dir_rm para eliminar el archivo no cifrado, en caso de haber cifrado, o cifrado, en caso contrario.

* Tambien se puede solo modificar la estructura de datos, cambiar el archivo original por el modificado.

* se usa la funcion dir_ren, para cambiar el nombre al final del proceso.

### Funcion make (crear archivo con contenido) 
### (Prueba Lista)

* abrir un archivo con el flag numero 1, se crea automaticamente si el archivo no existe

* Primero aprender a como crear un archivo y luego el contenido se escribe facilmente

### Funcion perror (?)

* No se que piden exactamente, asumo que que tiene que imprimir el retorno de cada metodo (codigo de ejecucion del metodo)

