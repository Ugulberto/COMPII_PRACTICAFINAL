.module morse

; MÓDULO PRINCIPAL: morse.asm
; Dependencias: stdio.asm, submenu1/mostrar_tabla.asm
; submenu2/caracter_a_caracter.asm, submenu2/palabra_a_palabra.asm submenu2/linea_a_linea.asm
; submenu3/caracter_a_caracter.asm, submenu3/palabra_a_palabra.asm, submenu3/linea_a_linea.asm

pantalla 	.equ 	0xFF00
fin			.equ	0xFF01
teclado 	.equ 	0xFF02

    .globl  nucleo					; morse.asm

	.globl  printStr				; stdio.asm
	.globl  printBreak				; stdio.asm

    .globl  mostrar_tabla			; submenu1/mostrar_tabla.asm

	.globl  caracter_a_caracter2	; submenu2/caracter_a_caracter.asm
	.globl	palabra_a_palabra2		; submenu2/palabra_a_palabra.asm
	.globl	linea_a_linea2			; submenu2/linea_a_linea.asm

 	.globl  caracter_a_caracter3	; submenu3/caracter_a_caracter.asm
 	.globl	palabra_a_palabra3		; submenu3/palabra_a_palabra.asm
	.globl	linea_a_linea3			; submenu3/linea_a_linea.asm

menu0:		
	.ascii	"\nPractica MORSE. v1.0\n"
    .ascii  "\n Menu DE OPCIONES:\n" 
    .ascii	"    1) Ver tabla\n"
    .ascii	"    2) Texto a MORSE\n"
    .ascii	"    3) MORSE a Texto\n"
    .ascii	"  S/s) Salir\n"
    .asciz	"\n >> Teclee una opcion: "

menu2:
    .ascii "\n\nOpcion 2. Texto a MORSE\n"
    .ascii "    1) Caracter a caracter\n"
    .ascii "    2) Palabra a palabra\n"
    .ascii "    3) Linea a linea\n"
    .ascii "  V/v) Volver\n"
    .asciz "\n >> Elige: "

menu3:
    .ascii "\n\nOpcion 3. MORSE a texto\n"
    .ascii "    1) Caracter a caracter\n"
    .ascii "    2) Palabra a palabra\n"
    .ascii "    3) Linea a linea\n"
    .ascii "  V/v) Volver\n"
    .asciz "\n >> Elige: "

incorrecta: 	.asciz "Opcion incorrecta!"

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
	beq 	submenu3	

	anda	#223		; Convierte a mayusculas
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


submenu3:	
	ldx		#menu3		; SALTO A LA DIRECCION DEL STRING DEL SUBMENÚ 3
	jsr 	printStr

	; Opcion del menu
	lda		teclado
	jsr		printBreak
	
	cmpa	#'1
	beq		char_a_char3
	cmpa	#'2
	beq		pal_a_pal3
	cmpa	#'3
	beq		lin_a_lin3

	anda	#223 ; convierte a mayusculas
	
	cmpa	#'V
	beq		nucleo

	ldx		#incorrecta
	jsr		printStr

	beq		submenu3
	

char_a_char3:
 	jsr 	caracter_a_caracter3
	bra 	submenu3

pal_a_pal3:
	jsr 	palabra_a_palabra3
	bra 	submenu3

lin_a_lin3:
	jsr 	linea_a_linea3
	bra 	submenu3

		
		; el programa acaba
acabar:	
	jsr		printBreak
	clra
	sta	fin
	
	.area 	FIJA (ABS)
	.org	0xFFFE		; vector de RESET	
	.word nucleo
