# Practica Final Computadores II
1er curso, 2º cuatrimestre. Grado en Ingeniería Informática. Facultad de Ciencias de la Universidad de Salamanca.

*BLANCO DE LA IGLESIA, DAVID*.

*RODRÍGUEZ FERNÁNDEZ, NICOLÁS*.
<br />
<br />

__Nota:__ Informe: **10.0**. <br />
&emsp;&emsp;&ensp;&nbsp;Defensa: **10.0**.
<br />
<br />

## Enunciado:
Se desea realizar un programa ensamblador 6809 que permita traducir de carácter alfanumérico a MORSE y viceversa.
<br />

Se solicita crear un menú funcional con los siguientes submenús y opciones:
<br />

    PrActica MORSE v0.1
            1) Ver tabla
            2) Texto a MORSE
            3) MORSE a Texto
          S/s) Salir
  
          Opción 2. Texto a MORSE 
                    1) Caracter a caracter 
                    2) Palabra a palabra 
                    3) Linea a linea 
                  V/v) Volver
          
          Opción 3. MORSE a Texto 
                    1) Caracter a caracter 
                    2) Palabra a palabra 
                    3) Linea a linea 
                  V/v) Volver
El resto de las indicaciones técnicas se encontraban en el PDF subido a Studium, llamado «Práctica de Computadores II - 2025-26 (MORSE).pdf».
<br />
<br />

## Arquitectura del proyecto
    COMPII_PRACTICAFINAL/            # Root del proyecto
    │
    ├─ libraries/                    # Bibliotecas de subrutinas (funciones)
    │   ├─ charMorse.asm             # Trductor texto <-> Morse
    │   ├─ stdio.asm                 # Prints e inputs
    │   └─ stringH.asm               # Cadenas y mayúsculas
    │
    ├─ submenu1/                     # Opción 1: Mostrar tabla
    │   └─ mostrar_tabla.asm         # Impresión por pantalla de la tabla de correspondencias
    │  
    ├─ submenu2/                     # Opción 2: Texto a Morse
    │   ├─ caracter_a_caracter.asm   # 2.1: char length
    │   ├─ linea_a_linea.asm         # 2.3: \n lenght
    │   └─ palabra_a_palabra.asm     # 2.2: word lenght
    │  
    ├─ submenu3/                     # Opción 3: Morse a texto
    │   ├─ caracter_a_caracter.asm   # 3.1: char length
    │   ├─ linea_a_linea.asm         # 3.3: \n lenght
    │   └─ palabra_a_palabra.asm     # 3.2: word lenght
    │    
    ├─ tables/                       # Tablas de caracteres
    │   ├─ chars_table.asm           # Caracteres ASCII A-Z y 0-9
    │   ├─ chars_table.inc           # Dependencias globales del archivo anterior
    │   ├─ morse_table.asm           # Correspondencias ASCII <-> Morse
    │   └─ morse_table.inc           # Dependencias globales del archivo anterior
    │  
    ├─ informe.pdf                   # Informe final como documentación del proyecto
    ├─ ensamblar.sh                  # Script de Shell para ejecutar el proyecto
    ├─ morse.asm                     # Archivo MAIN: menú principal y parrilleo de subrutinas
    └─ readme.md                     # Guía de lectura del proyecto

## Ejecución:
Disponemos de un .sh para facilitar la ejecución del programa. 
El ejecutar.sh servirá para ejecutar y borrar los archivos .rel .rst .map .lst. Para que funcione deberemos poner:
> chmod +x ejecutar.sh

y posteriormente ejecutar
> ./ensamblar.sh

en terminal.

<br />

## Historial de versiones:
<br />

    v. 0: "Borrador" ......... 19/04/2026
        v. 0.0: "Menu0" ...... 19/04/2026 
        v. 0.1: "SubM1" ...... 21/04/2026
        v. 0.2: "SubM2" ...... 01/05/2026
            v.0.2.1: "S+B" ... 03/05/2026
        v. 0.3: "SubM3" ...... 06/05/2026
            
    v.1.0: "Entrega" ......... 07/05/2026
<br />

*Nota: &ensp;mencionamos la versión "S+B" debido a su importancia.*
<br />
&emsp;&emsp;&ensp;&ensp;*"S+B" significa "Structure+Buffer", estructura y búfer.*
<br />
&emsp;&emsp;&ensp;&ensp;*En ella se reestructuró el proyecto, Y a su vez se*
<br />
&emsp;&emsp;&ensp;&ensp;*transformó para hacer un uso más responsable de la memoria.*
