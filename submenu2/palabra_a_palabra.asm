.module         palabra_a_palabra2

; Dependencias: stdio.asm, stringH.asm, charMorse.asm

pantalla        .equ    0xFF00
fin             .equ    0xFF01
teclado         .equ    0xFF02

.globl      palabra_a_palabra2      ; palabra_a_palabra.asm
.globl      printnStr               ; stdio.asm
.globl      printBreak              ; stdio.asm
.globl      printStr                ; stdio.asm
.globl      is_alphanum             ; stringH.asm
.globl      char_a_morse            ; charMorse.asm

mensaje_inicio:     .asciz  "2.2) Texto a MORSE (Palabra a Palabra):"
cadena_introducida: .rmb    101
max_tam:            .byte   100
mensaje_max_tam:    .asciz  "\nSe ha excedido el maximo de caracteres (100) y se ha cortado la entrada."

palabra_a_palabra2:
    pshs    a,b,x,y
    jsr     printBreak
    ldx     #mensaje_inicio
    jsr     printStr
    jsr     printBreak

bucle_palabra_a_palabrabr:
    jsr     printBreak
    ldx     #cadena_introducida     ; direccion de la cadena a introducir
    ldb     max_tam                 ; tamanio maximo de la cadena a introducir
bucle_palabra_a_palabra:
    lda     teclado

    cmpa    #' 
    beq     imprimir_caracteres_palabra_a_palabrabr

    cmpa    #'\n
    beq     imprimir_caracteres_palabra_a_palabra

    pshs    b
    jsr     is_alphanum
    tstb
    beq     salir_palabra_a_palabra
    puls    b

    sta     ,x+
    decb
    cmpb    #0
    beq     imprimir_caracteres_palabra_a_palabratam
    bra     bucle_palabra_a_palabra

imprimir_caracteres_palabra_a_palabratam: ; esto se ejecuta si se ha superado el maximo de caracteres
    pshs    x
    ldx     #mensaje_max_tam
    jsr     printStr
    puls    x
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
    puls    b           ; cuando salgo del bucle el registro b había sido encapsulado ya
    puls    a,b,x,y
    rts