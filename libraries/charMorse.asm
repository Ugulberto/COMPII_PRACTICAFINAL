		.module  charMorse

; Módulo charMorse
; Creado por: David Blanco de la Iglesia
; Dependencias: stringH.asm morse_table.inc chars_table.inc

.include "tables/morse_table.inc"
.include "tables/chars_table.inc"

teclado  .equ    0xFF02
pantalla .equ    0xFF00

.globl  char_a_morse	; charMorse.asm
.globl	morse_a_char	; charMorse.asm
.globl	inputMorse		; charMorse.asm
.globl	strcmp			; stringH.asm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Función char_a_morse: devuelve la direccion de inicio del codigo morse  ;
; correspondiente al caracter introducido en el registro A. Pasa de		  ;
; minúscula a mayúscula automáticamente cuando se necesite.               ;
;                                                                         ;
; Entrada:                       										  ;
;   - A: Caracter del que se desea encontrar el codigo morse              ;
;                                                                         ;
; Salida:                                                                 ;
;   - X: direccion de inicio del codigo morse en la tabla_morse           ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

char_a_morse:
	pshs	a,b

	cmpa    #'a
    blo     iniciar_busqueda_char_a_morse    ; Si es menor que 'a', no es minúscula
    cmpa    #'z
    bhi     iniciar_busqueda_char_a_morse    ; Si es mayor que 'z', tampoco
    suba    #32 

	iniciar_busqueda_char_a_morse:
	    ; Buscamos el índice en la tabla chars_table
	    ldx     #chars_table
	    ldb     #0                  ; B = índice

	buscar_idx_char_a_morse:
	    cmpa    ,x                  ; Compara A con el carácter en la tabla
	    beq     encontrado_char_a_morse      
	
	    leax    1,x                 ; SALTAMOS 1 BYTE 
	    incb                        ; Siguiente índice
	    cmpb    chars_table_Total   ; Fin de la tabla
	    blt     buscar_idx_char_a_morse
	
		; Si ha llegado aquí, el caracter introducido no esta en la tabla
	    bra		salir_char_a_morse ; vuelvo

	encontrado_char_a_morse:
	    ; Usamos el índice encontrado para acceder a la misma posicion en tabla_morse
	    ; el registro A se va a sobrescribir para la multiplicación
	    lda     #6
	    mul                         ; D = A * B (6 * índice)
	    addd    #tabla_morse
	    tfr     d,x ; ponemos en el registro x la direccion del caracter morse
	
	salir_char_a_morse:
	puls	a,b
	rts


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Función morse_a_char: busca en la tabla de codigos Morse el equivalente ;
; en caracter ASCII de la cadena introducida.                             ;
;                                                                         ;
; Entrada:                                                                ;
;   - X: direccion de memoria de la cadena Morse a comparar               ;
;                                                                         ;
; Salida:                                                                 ;
;   - X: direccion del caracter equivalente en la tabla_chars             ;
;   - B: codigo de estado                                                 ;
;        0 -> encontrado correctamente                                    ;
;        1 -> codigo Morse no valido                                      ;
;                                                                         ;
; Notas:                                                                  ;
;   - La cadena debe estar terminada en NULL (0)                          ;
;   - La comparacion se realiza con las tablas tabla_morse y              ;
;     tabla_chars                                                         ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

morse_a_char:
	pshs	a,y				; B es para la salida y X también
iniciar_busqueda_morse_a_char:
	ldb		#0				; índice
	ldy		#tabla_morse	; direccion del inicio de la tabla

buscar_morse_a_char:
	pshs	b
	jsr		strcmp			; B = 1 son iguales
	tstb
	bne		fin_buscar_morse_a_char
	puls	b

	leay	6,y
	incb

	cmpb	tabla_morse_Total
	beq 	no_encontrado_morse_a_char		;no lo he encontrado

	bra		buscar_morse_a_char

fin_buscar_morse_a_char:
	puls	b				; venia de codigo encapsulado
	lda		#0				; a podia contener cualquier cosa
	addd	#chars_table
	tfr		d,x

	ldb		#0				; éxito
	bra		fin_morse_a_char

no_encontrado_morse_a_char:	
	ldb		#1

fin_morse_a_char:
	puls	a,y
	rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Función inputMorse: lee desde teclado una secuencia de puntos y rayas   ;
; hasta encontrar un separador (espacio o salto de línea).                ;
; La cadena se almacena en memoria en la direccion indicada por X.        ;
;                                                                         ;
; Entrada:                                                                ;
;   - X: direccion de memoria donde se guardará la cadena Morse           ;
;                                                                         ;
; Salida:                                                                 ;
;   - B: codigo de estado                                                 ;
;        0 -> lectura correcta                                            ;
;        1 -> caracter ilegal introducido                                 ;
;        2 -> separador sin contenido (doble espacio o enter directo)     ;
;        3 -> longitud mayor de la permitida                              ;
;                                                                         ;
; Notas:                                                                  ;
;   - La cadena se termina en NULL (0)                                    ;
;   - Solo se permiten '.' y '-'                                          ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

inputMorse:
	pshs	x
	ldb		#0						; contador

inputMorse_bucle:
	lda		teclado

	cmpa	#' 
	beq		inputMorse_comprobFin

	cmpa	#'\n
	beq		inputMorse_comprobFin

	cmpa	#45
	blo		inputMorse_noPermitido

	cmpa	#46
	bhi		inputMorse_noPermitido
	
	incb

	cmpb	#6
	beq		inputMorse_errorLongitudEnc

	sta		,x+
	bra		inputMorse_bucle

inputMorse_noPermitido:
	ldb		#0
	stb		,x				; Poner terminador aunque haya error
	ldb		#1
	bra		inputMorse_fin

inputMorse_comprobFin:
	; En a hay un espacio o un salto de linea: lo detecto
    tstb
    beq     inputMorse_errorLongitudDeb  ; Si no escribió nada, error

inputMorse_relleno:
    cmpb    #5                        ; ¿Ya tenemos 5 caracteres?
    beq     inputMorse_terminar       ; Si sí, vamos a poner el \0
    
	pshs	a					
    lda     #'                         ; Cargar espacio ASCII (32)
    sta     ,x+                       ; Guardar y avanzar
    incb                              ; Incrementar contador de relleno
	puls	a

	; cuando salga del bucle a seguirá siendo espacio o salto de línea
    bra     inputMorse_relleno        ; Repetir hasta llegar a 5


inputMorse_terminar:
    ldb     #0                        ; \0
    stb     ,x                        ; Lo guardamos (sin + para no pasarnos)
	; B se queda en 0 (exito)
    bra     inputMorse_fin

inputMorse_errorLongitudDeb:
	ldb		#0
	stb		,x				; Poner terminador aunque haya error
	ldb		#2
	bra		inputMorse_fin

inputMorse_errorLongitudEnc:
	ldb		#0
	stb		,x				; Poner terminador aunque haya error (>5 caracteres)
	ldb		#3

inputMorse_fin:
	puls	x
	rts
