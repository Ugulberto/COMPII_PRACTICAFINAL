.module     palabra_a_palabra2

pantalla    .equ    0xFF00
fin         .equ    0xFF01
teclado     .equ    0xFF02

    .globl      palabra_a_palabra2
    .globl      printnStr
    .globl      printBreak
    .globl      printStr
    .globl      printHex
    .globl      chars_table
	.globl		chars_table_Total
    .globl      tabla_morse
    .globl      strcmp
    .globl      is_alphanum
    .globl      char_a_morse

mensaje_inicio:     .asciz  "2.2) Texto a MORSE (Palabra a Palabra):"
cadena_introducida: .rmb    80
max_tam:            .byte   #80

palabra_a_palabra2:
    pshs    a,b,x,y
    jsr     printBreak
    ldx     #mensaje_inicio
    jsr     printStr
    jsr     printBreak

bucle_palabra_a_palabrabr:
    jsr     printBreak
    ldx     #cadena_introducida     ; direccion de la cadena a introducir
bucle_palabra_a_palabra:
    lda     teclado

    cmpa    #' 
    beq     imprimir_caracteres_palabra_a_palabrabr

    cmpa    #'\n
    beq     imprimir_caracteres_palabra_a_palabra

    jsr     is_alphanum
    cmpb    #0
    beq     salir_palabra_a_palabra

    sta     ,x+
    bra     bucle_palabra_a_palabra
    
imprimir_caracteres_palabra_a_palabrabr:
    jsr     printBreak
imprimir_caracteres_palabra_a_palabra:
    lda     #'\0
    sta     ,x+
    ldy     #cadena_introducida
bucle_imprimir_caracteres:
    lda     ,y+

    cmpa    #'\0
    beq     bucle_palabra_a_palabrabr ; Si he llegado al final de la cadena, salgo

    jsr     char_a_morse

    ; Imprimo el contenido de X
    ldb     #6
    jsr     printnStr

    lda     #' 
    sta     pantalla

    bra     bucle_imprimir_caracteres


salir_palabra_a_palabra:
    puls    a,b,x,y
    rts