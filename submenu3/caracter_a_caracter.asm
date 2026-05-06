.module     caracter_a_caracter3

; Dependencias: stringH.asm y charMorse.asm

pantalla    .equ    0xFF00
fin         .equ    0xFF01
teclado     .equ    0xFF02

    .globl      caracter_a_caracter3 ; caracter_a_caracter.asm
    .globl      printBreak           ; stringH.asm
    .globl      printStr             ; stringH.asm
    .globl      morse_a_char         ; charMorse.asm
    .globl      inputMorse           ; charMorse.asm


mensaje_inicio:     .asciz  "3.1) MORSE a Texto (Caracter a Caracter):"
mensaje_ilegal:     .asciz  "ERROR CARACTER ENTRADA"
mensaje_longitud:   .asciz  "ERROR LONGITUD ENTRADA"
mensaje_invalido:   .asciz  "CODIGO NO VALIDO"
caracter_actual:    .rmb    6

caracter_a_caracter3:
    pshs    a,b,x ; Solo introduzco los registros que uso
    ldx     #mensaje_inicio
    jsr     printStr
    jsr     printBreak

bucle_cac3:
    ldx     #caracter_actual
    jsr     inputMorse

    cmpb    #1
    beq     error_ilegal

    cmpb    #2
    beq     error_longitud

    cmpb    #3
    beq     error_longitud

    ; Si llega hasta aqui la sintaxis del caracter es valida.

    jsr     morse_a_char

    cmpb    #1          ; no encontrado
    beq     error_invalido

    ; El caracter fue encontrado y debo imprimir lo que haya en x
    lda     #'-
    sta     pantalla
    lda     #'>
    sta     pantalla
    jsr     printStr
    jsr     printBreak
    bra     bucle_cac3


error_ilegal:
    lda     #' 
    sta     pantalla
    ldx     #mensaje_ilegal
    jsr     printStr
    bra     salir_cac3

error_longitud:
    lda     #' 
    sta     pantalla
    ldx     #mensaje_longitud
    jsr     printStr
    bra     salir_cac3

error_invalido:
    ldx     #mensaje_invalido
    jsr     printStr

salir_cac3:
    puls    a,b,x
    rts