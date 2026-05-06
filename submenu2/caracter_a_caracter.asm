.module     caracter_a_caracter2

; Dependencias: stdio.asm, stringH.asm, charMorse.asm

pantalla    .equ    0xFF00
fin         .equ    0xFF01
teclado     .equ    0xFF02

    .globl      caracter_a_caracter2        ; caracter_a_caracter.asm
    .globl      printnStr                   ; stdio.asm
    .globl      printBreak                  ; stdio.asm
    .globl      printStr                    ; stdio.asm
    .globl      is_alphanum                 ; stringH.asm
    .globl      char_a_morse                ; charMorse.asm


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