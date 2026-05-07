.module     linea_a_linea2

; Dependencias: stdio.asm, charMorse.asm

pantalla    .equ    0xFF00
fin         .equ    0xFF01
teclado     .equ    0xFF02

    .globl      linea_a_linea2          ; linea_a_linea.asm
    .globl      printnStr               ; stdio.asm
    .globl      printBreak              ; stdio.asm
    .globl      printStr                ; stdio.asm
    .globl      inputnAlphanum          ; stdio.asm
    .globl      char_a_morse            ; charMorse.asm

mensaje_inicio:     .asciz  "2.3) Texto a MORSE (Linea a Linea):"
cadena_introducida: .rmb    101
max_tam:            .byte   100
mensaje_max_tam:    .asciz  "\nSe ha excedido el maximo de caracteres (100) y se ha cortado la entrada.\n"

linea_a_linea2:
    pshs    a,b,x,y
    jsr     printBreak
    ldx     #mensaje_inicio
    jsr     printStr
    jsr     printBreak

bucle_linea_a_linea:
    ldx     #cadena_introducida ; inputAlphanum suele esperar el destino en X
    ldb     max_tam             ; tamanio maximo de la cadena de entrada
    jsr     inputnAlphanum       ; B=0 si OK (\n), B=1 si error (no alfanum)

    ; Si el usuario introduce algo no alfanumérico, salimos
    cmpb    #1
    beq     salir_linea_a_linea

    ; Si se llego al maximo de caracteres, lo informamos
    cmpb    #2
    beq     bucle_imprimir_caracteres_maxtam
    
    ; Preparamos Y para recorrer la cadena que acabamos de leer
    ldy     #cadena_introducida
    bra     bucle_imprimir_caracteres

bucle_imprimir_caracteres_maxtam:
    pshs    x
    ldx     #mensaje_max_tam
    jsr     printStr
    puls    x
    ldy     #cadena_introducida

bucle_imprimir_caracteres:
    lda     ,y+              
    beq     final_de_linea 

    cmpa    #'      
    beq     imprimir_espacio_morse

    ; Convertimos carácter a dirección Morse en X
    jsr     char_a_morse

    ; Imprimir el Morse
    ldb     #6
    jsr     printnStr 
    
    ; Imprimimos un espacio de separación entre letras Morse
    lda     #' 
    sta     pantalla
    bra     bucle_imprimir_caracteres

imprimir_espacio_morse:
    lda     #' 
    sta     pantalla
    sta     pantalla
    bra     bucle_imprimir_caracteres

final_de_linea:
    jsr     printBreak          ; Salto de línea antes de la siguiente entrada
    bra     bucle_linea_a_linea

salir_linea_a_linea:
    puls    a,b,x,y
    rts