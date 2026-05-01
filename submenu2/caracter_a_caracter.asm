.module     caracter_a_caracter2

pantalla    .equ    0xFF00
fin         .equ    0xFF01
teclado     .equ    0xFF02

    .globl      caracter_a_caracter2
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


mensaje_inicio:     .asciz  "2.1) Texto a MORSE (Caracter a Caracter):"
espacios:           .asciz  "(  )"
caracter_actual:    .asciz  ""
direccion:          .word   0

caracter_a_caracter2:
    pshs    a,b,x ; Solo introduzco los registros que uso
    jsr     printBreak
    ldx     #mensaje_inicio
    jsr     printStr
    jsr     printBreak
    jsr     printBreak

bucle_caracter_a_caracter:
    ; Pulsar tecla
    lda     teclado
    beq     bucle_caracter_a_caracter         ; Si es 0, es el caracter de final de string luego no se pulsó ninguna tecla     

    ; ¿Es un espacio?
    cmpa    #32                 
    beq     imprimir_espacio

    jsr     is_alphanum
    cmpb    #0
    beq     salir_caracter_a_caracter
    
    jsr     char_a_morse 
    ; en X esta guardada la direccion de inicio del codigo morse equivalente al caracter que estaba en el registro A

    ; Imprimir ( Morse )
    lda     #'(
    sta     pantalla

	ldb 	#6
    jsr     printnStr            ; Imprime el codigo morse quitando espacios del final

    lda     #')
    sta     pantalla

    jsr     printBreak          ; Salto de línea para el siguiente carácter
	bra		bucle_caracter_a_caracter

imprimir_espacio:
    ; Como la tecla espacio ya se mandó a "pantalla" arriba, 
    ; aquí solo imprimimos el "(  )" y saltamos de línea.
    ldx     #espacios
    jsr     printStr
    jsr     printBreak
    bra     bucle_caracter_a_caracter

salir_caracter_a_caracter:
    puls    a,b,x
    rts