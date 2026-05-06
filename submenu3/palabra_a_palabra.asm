.module     palabra_a_palabra3

; Dependencias: stringH.asm y charMorse.asm

pantalla    .equ    0xFF00
fin         .equ    0xFF01
teclado     .equ    0xFF02

    .globl      palabra_a_palabra3  ; palabra_a_palabra.asm
    .globl      printBreak          ; stringH.asm
    .globl      printStr            ; stringH.asm
    .globl      morse_a_char        ; charMorse.asm
    .globl      inputMorse          ; charMorse.asm

; --- SECCIÓN DE DATOS ---
mensaje_inicio:     .asciz  "3.2) MORSE a Texto (Palabra a Palabra):"
cadena_introducida: .rmb     6
traduccion:         .rmb     101
max_tam:            .byte    100
mensaje_max_tam:    .asciz  "\nSe ha excedido el maximo de caracteres (100) y se ha cortado la entrada.\n"
mensaje_ilegal:     .asciz  "ERROR CARACTER ENTRADA"
mensaje_longitud:   .asciz  "ERROR LONGITUD ENTRADA"
mensaje_invalido:   .asciz  "CODIGO NO VALIDO"

palabra_a_palabra3:
    pshs    a,b,x,y                     ; Guardamos registros
    jsr     printBreak
    ldx     #mensaje_inicio
    jsr     printStr
    jsr     printBreak

    ldy     #traduccion                 ; Y apunta al buffer de la frase
    
bucle_palabra_a_palabra:
    ; Limpiamos el buffer temporal de la letra
    ldx     #cadena_introducida
    lda     #0
    sta     ,x
    
    ldx     #cadena_introducida 
    ldb     max_tam                     ; Pasamos el límite de 100
    jsr     inputMorse          

    ; Comprobamos el código de retorno en B
    cmpb    #1
    lbeq    error_ilegal                ; B=1: Caracter prohibido

    cmpb    #2
    lbeq    chequear_fin_de_palabra     ; B=2: Separador o fin de linea

    cmpb    #3
    lbeq    error_longitud_real         ; B=3: Mas de 5 puntos/rayas
    
    ; Si B=0, procedemos a traducir la letra
    pshs    a                           ; Guardamos el separador (espacio/enter)
    
    ldx     #cadena_introducida
    jsr     morse_a_char     
    tstb
    lbne    error_invalido              ; Si B != 0, el código morse no existe

    ; Guardamos el carácter traducido en el buffer frase
    lda     ,x
    sta     ,y+ 

    ; CONTROL maximo tamanio 100 caracteres
    tfr     y,d                        ; D = puntero actual
    subd    #traduccion                 ; Restamos inicio para tener la cuenta
    cmpb    max_tam                     
    lbhs    limite_maximo_alcanzado     ; Si llegamos a 100, cortamos

    ; Recuperamos separador para ver si hay que terminar
    puls    a
    cmpa    #'\n
    beq     imprimir_y_salir
    
    bra     bucle_palabra_a_palabra

chequear_fin_de_palabra:
    cmpa    #'\n
    beq     imprimir_y_salir            ; Si es Enter, fin del programa
    
    ; Si es doble espacio, imprimimos palabra acumulada
    clr     ,y
    jsr     printBreak
    ldx     #traduccion
    jsr     printStr
    ldy     #traduccion                 ; Reiniciamos puntero para nueva palabra
    jsr     printBreak          
    bra     bucle_palabra_a_palabra

imprimir_y_salir:
    clr     ,y                          ; Terminador nulo
    ldx     #traduccion
    jsr     printStr
    lbra    salir_palabra_a_palabra

; CODIGOS DE ERROR

limite_maximo_alcanzado:
    puls    a                           ; Limpiar stack
    clr     ,y
    ldx     #mensaje_max_tam
    jsr     printStr
    ldx     #traduccion
    jsr     printStr
    jsr     printBreak
    ldy     #traduccion
    lbra    bucle_palabra_a_palabra

error_invalido:
    puls    a                           ; Limpiar stack
    ldx     #mensaje_invalido
    jsr     printStr
    jsr     printBreak
    bra     imprimir_y_salir

error_longitud_real:
    lda     #' 
    sta     pantalla
    ldx     #mensaje_longitud
    jsr     printStr
    jsr     printBreak
    bra     imprimir_y_salir

error_ilegal:
    lda     #' 
    sta     pantalla
    ldx     #mensaje_ilegal
    jsr     printStr
    jsr     printBreak
    bra     imprimir_y_salir

salir_palabra_a_palabra:
    puls    a,b,x,y                     ; Restauramos registros
    rts