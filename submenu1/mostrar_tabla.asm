.module     mostrar_tabla

; Dependencias: stdio.asm morse_table.inc chars_table.inc

.include "tables/morse_table.inc"
.include "tables/chars_table.inc"


pantalla 	.equ 	0xFF00
fin		    .equ	0xFF01
teclado 	.equ 	0xFF02

    .globl      mostrar_tabla       ; mostrar_tabla.asm  
    .globl      printnStr           ; stdio.asm
    .globl      printBreak          ; stdio.asm
    .globl      printStr            ; stdio.asm

mensaje_inicio:     .asciz  "\n1) TABLA MORSE:"
flecha:             .asciz  "->"

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

        lda     ,y+
        sta     pantalla

        pshs    x
        ldx     #flecha
        jsr     printStr
        puls    x

        ldb #6  ; parámetro para printnStr
        jsr     printnStr
        jsr     printBreak

        puls b
        leax 6,x     ; avanzar a la siguiente cadena

        decb
        bne bucle_tabla

    puls    a,b,x,y
    rts
