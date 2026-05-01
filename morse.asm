.module morse
		
.include "morse_table.inc"

		; definicion de constantes
pantalla 	.equ 	0xFF00
fin			.equ	0xFF01
teclado 	.equ 	0xFF02

      	.globl  programa

; Global Functions de stdio.asm
	.globl  printStr
    .globl  printnStr
	.globl  printBreak
	.globl  inputStr
	.globl	printInt
	.globl  printHex

; Global Functions de stringH.asm
	.globl  strcmp

    .globl  mostrar_tabla

	.globl  caracter_a_caracter2
	.globl	palabra_a_palabra2
	.globl	linea_a_linea2

menu0:		
		.ascii	"\nPractica MORSE\n"
      	.ascii  "\n Menu DE OPCIONES:\n" 
      	.ascii	"    1) Ver tabla\n"
      	.ascii	"    2) Texto a MORSE\n"
      	.ascii	"    3) MORSE a Texto\n"
      	.ascii	"  S/s) Salir\n"
      	.asciz	"\n >> Teclee una opcion: "

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; RECOMENDACIÓN GENERAL 												    ;
; Para las opciones de “Carácter a carácter”, “Palabra a palabra” y “Línea  ;
; a línea”, si se tiene una subrutina encargada de leer el código morse,    ;
; almacenarlo en un buffer y devolver un código de OK o error (indicando    ;
; el tipo de error), facilita la realización del programa, de manera que si ;
; devuelve un OK se busca la cadena y caso contrario, se muestra el error   ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; teacher's tip 2:																			;
; La opción 2 a partir del código ASCII leído es fácil calcular el índice en la tabla.		;
; ‘A es el 0, la ‘Z el 25, el ‘0 el 26 y el ‘9 el 35. Sabiendo la longitud de cada cadena	;
; (6) es fácil colocarse en la posición inicial del código morse correspondiente. 			;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

menu2:
          .ascii "\nTexto a MORSE\n"
          .ascii "  1) Caracter a caracter\n"
          .ascii "  2) Palabra a palabra\n"
          .ascii "  3) Linea a linea\n"
          .ascii "V/v) Volver\n"
          .asciz " >> Elige: "

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
; teacher's tip 3:															;
; La opción 3 se puede plantear como leer ‘. y ‘- hasta que se pulse el   	;
; espacio y almacenado en un buffer del mismo tamaño de las cadenas de 		;
; la tabla. Si el código tiene menos de 5 ‘. o ‘- rellenarlo con espacios. 	;
; A partir de ahí, se compara esa cadena con las cadenas de la tabla de 	;		
; códigos y si coincide, sabiendo el índice de la cadena comparada se tiene ;
; el carácter ASCII (Es posible hacerlo a través del árbol binario Morse).	;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

menu3:
          .ascii "\nMORSE a texto\n"
          .ascii "  1) Caracter a caracter\n"
          .ascii "  2) Palabra a palabra\n"
          .ascii "  3) Linea a linea\n"
          .ascii "V/v) Volver\n"
          .asciz " >> Elige: "

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; me faltan de hacer un par de cosinas:                       ;
;    - meter que los submenús sean cíclicos                   ;
;    - hacer los submenús 2.:1,2,3  y  3.:1,2,3               ;
;    - lo que he hecho con submenu1 es ridículo, sí, pero es  ;
;        un placeholder, lo que tengo que ver es como hacer   ;
;        para que lo pille directamente de morse_table.asm    ;
;    - terminar de indicar los teacher's tips                 ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

incorrecta: 	.asciz "Opcion incorrecta!"
	
		
programa:

		
nucleo:		
    ldx		#menu0
	jsr 	printStr
	lda 	teclado

	; comprueba que es un valor valido
	cmpa 	#'1
	beq 	submenu1	
	cmpa 	#'2		
	beq 	submenu2	
	cmpa 	#'3		
	beq 	mostrar_submenu3	

	anda	#223
	cmpa 	#'S		
	beq 	acabar

	jsr		printBreak
	ldx		#incorrecta
	jsr		printStr
	bra		nucleo
		
submenu1:	
	jsr     mostrar_tabla		
	bra		nucleo
		
submenu2:	
	ldx		#menu2		; SALTO A LA SUBRUTINA DEL SUBMENÚ 2
	jsr 	printStr

	; Debo pedir ahora la opcion del menu
	lda		teclado
	jsr		printBreak
	
	cmpa	#'1
	beq		char_a_char2
	cmpa	#'2
	beq		pal_a_pal2
	cmpa	#'3
	beq		lin_a_lin2

	anda	#223 ; convierte a mayusculas
	
	cmpa	#'V
	beq		nucleo

	ldx		#incorrecta
	jsr		printStr

	beq		submenu2
	

char_a_char2:
	jsr 	caracter_a_caracter2
	bra 	submenu2

pal_a_pal2:
	jsr 	palabra_a_palabra2
	bra 	submenu2

lin_a_lin2:
	jsr 	linea_a_linea2
	bra 	submenu2


mostrar_submenu3:	
	ldx #menu3		; SALTO A LA SUBRUTINA DEL SUBMENÚ 3
	jsr printStr

exe_submenu3:	
	bra nucleo

		
		; el programa acaba
acabar:	
	jsr		printBreak
	clra
	sta	fin
	
	.area 	FIJA (ABS)
	.org	0xFFFE		; vector de RESET	
	.word programa
