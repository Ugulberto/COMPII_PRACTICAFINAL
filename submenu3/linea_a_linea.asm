.module     linea_a_linea3

; Dependencias: stringH.asm y charMorse.asm

pantalla    .equ    0xFF00
fin         .equ    0xFF01
teclado     .equ    0xFF02

    .globl      linea_a_linea3      ; linea_a_linea.asm
    .globl      printBreak          ; stringH.asm
    .globl      printStr            ; stringH.asm
    .globl      morse_a_char        ; charMorse.asm
    .globl      inputMorse          ; charMorse.asm

mensaje_inicio:     .asciz  "3.3) MORSE a Texto (Linea a Linea):"
cadena_introducida: .rmb     6
traduccion:         .rmb     101
max_tam:            .byte    100
mensaje_max_tam:    .asciz  "\nSe ha excedido el maximo de caracteres (100) y se ha cortado la entrada.\n"
mensaje_ilegal:     .asciz  "ERROR CARACTER ENTRADA"
mensaje_longitud:   .asciz  "ERROR LONGITUD ENTRADA"
mensaje_invalido:   .asciz  "CODIGO NO VALIDO"

linea_a_linea3:
    pshs    a,b,x,y                     ; Guardamos registros
    jsr     printBreak
    ldx     #mensaje_inicio
    jsr     printStr
    jsr     printBreak

    ldy     #traduccion                 ; Y apunta al buffer de la frase completa
    
bucle_linea:
    ; Limpiamos el buffer temporal de la letra
    ldx     #cadena_introducida
    lda     #0
    sta     ,x
    
    ldx     #cadena_introducida 
    ldb     max_tam                     ; Límite de 100
    jsr     inputMorse          

    ; Comprobamos el código de retorno en B
    cmpb    #1
    lbeq    error_ilegal                ; B=1: Caracter prohibido

    cmpb    #2
    beq     manejar_espacios            ; B=2: Doble espacio o Enter sin letra

    cmpb    #3
    lbeq    error_longitud_real         ; B=3: Mas de 5 símbolos
    
    ; Si B=0, traducimos letra
    pshs    a                           ; Guardamos separador (espacio/enter)
    
    ldx     #cadena_introducida
    jsr     morse_a_char     
    tstb
    lbne    error_invalido              ; Código morse no existe

    ; Guardamos el carácter en el buffer de la línea
    lda     ,x
    sta     ,y+ 

    ; CONTROL maximo tamanio 100 caracteres
    tfr     y,d
    subd    #traduccion
    cmpb    max_tam
    lbhs    limite_maximo_alcanzado_a

    ; Miramos si el separador era un Enter
    puls    a
    cmpa    #'\n
    beq     imprimir_y_seguir            ; Si es Enter, imprimimos toda la línea
    
    bra     bucle_linea                 ; Si era espacio, seguimos pidiendo letra

manejar_espacios:
    ; Si inputMorse devuelve B=2 es porque detectó un separador sin contenido
    cmpa    #'\n
    beq     imprimir_y_seguir            ; Enter -> Imprimir lo que haya
    
    ; Si es un espacio (doble espacio en morse), añadimos un espacio al texto
    lda     #' 
    sta     ,y+
    
    ; Volvemos a chequear el límite tras añadir el espacio
    tfr     y,d
    subd    #traduccion
    cmpb    max_tam
    lbhs    limite_maximo_alcanzado
    
    bra     bucle_linea

imprimir_y_seguir:
    clr     ,y                          ; Terminador nulo
    ldx     #traduccion
    jsr     printStr
    jsr     printBreak
    ldy     #traduccion                 ; vuelvo a escribir para no acumular entre llamadas
    lbra    bucle_linea

; --- CODIGOS DE ERROR ---
limite_maximo_alcanzado_a:
    puls    a
limite_maximo_alcanzado:                         ; Limpiar stack si venimos de lectura OK
    clr     ,y                          ; \0
    ldx     #mensaje_max_tam
    jsr     printStr
    ldx     #traduccion
    jsr     printStr
    jsr     printBreak
    ldy     #traduccion
    lbra    bucle_linea

error_invalido:
    puls    a                           ; Limpiar stack
    clr     ,y
    lda     #'                          ; Espacio visual
    sta     pantalla
    ldx     #mensaje_invalido
    jsr     printStr
    jsr     printBreak
    ldx     #traduccion                 ; Imprimimos lo que llevábamos bien
    jsr     printStr
    bra     salir_linea

error_longitud_real:
    clr     ,y
    lda     #' 
    sta     pantalla
    ldx     #mensaje_longitud
    jsr     printStr
    jsr     printBreak
    ldx     #traduccion
    jsr     printStr
    bra     salir_linea

error_ilegal:
    clr     ,y
    lda     #' 
    sta     pantalla
    ldx     #mensaje_ilegal
    jsr     printStr
    jsr     printBreak
    ldx     #traduccion
    jsr     printStr
    bra     salir_linea

salir_linea:
    puls    a,b,x,y                     ; Restauramos
    rts