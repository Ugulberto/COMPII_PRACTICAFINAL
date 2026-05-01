.module main

fin     	.equ 	0xFF01
teclado	    .equ	0xFF02
pantalla 	.equ 	0xFF00

            .area PROG (ABS)
        	.org 	0x1000	

            .globl printStr, printBreak, printHex, printInt ; funciones de stdio.asm
            .globl programa

msg_inicio: .asciz "Probando printHex con el valor 165: "
msg_medio:  .asciz "Probando printInt con el valor 95: "
msg_fin: .asciz "Prueba finalizada."

; modulo de prueba para stdio.asm

programa:

    ldx    #msg_inicio
    jsr    printStr

    lda    #165
    jsr    printHex
    
    jsr    printBreak

    ldx     #msg_medio
    jsr     printStr

    lda     #6
    jsr     printInt

    jsr     printBreak

    ldx    #msg_fin
    jsr    printStr

    bra acabar

acabar: 	
	lda	#'\n
	sta	    pantalla
	clra
	sta 	fin

	.org 	0xFFFE
	.word 	programa

