.module     mostrar_tabla

.include "morse_table.inc"
.include "chars_table.inc"

pantalla 	.equ 	0xFF00
fin		    .equ	0xFF01
teclado 	.equ 	0xFF02

    .globl      mostrar_tabla
    .globl      printnStr
    .globl      printBreak
    .globl      printStr

mensaje_inicio:     .asciz  "1) TABLA MORSE:"
flecha:             .asciz  "->"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; COMENTARIO PARA LA FUNCION MOSTRAR_TABLA TABLA DEL MENU1              ;
;                                                                       ;
; teachers tip:                                                         ; 
; La opción 1 “ver tabla” habrá que imprimir 36 cadenas de 5 caracteres ;
; contenidas en la tabla entregada, las  26 primeras corresponden a     ;
; caracteres de la ‘A a la ‘Z (contiguos en código ASCII) y los 10      ;
; siguientes del ‘0 al ‘9 (también contiguos en código ASCII).          ;                                                         
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
mostrar_tabla:
    pshs    a,b,x,y

    jsr printBreak

    ldx #mensaje_inicio
    jsr printStr

    ldx #tabla_morse
    ldy #chars_table
    ldb tabla_morse_Total          ; número de elementos

    jsr printBreak
    jsr printBreak

    bucle_tabla:
        pshs b

        pshs    x
        tfr     y,x
        jsr     printnStr
        ldx     #flecha
        jsr     printStr
        puls    x

        ldb #6  ; parámetro para printnStr
        jsr     printnStr
        jsr     printBreak

        puls b
        leax 6,x     ; avanzar a la siguiente cadena
        leay 2,y

        decb
        bne bucle_tabla

    puls    a,b,x,y
    rts
