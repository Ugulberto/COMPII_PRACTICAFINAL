		.module  charMorse

; Módulo charMorse
; Creado por: David Blanco de la Iglesia
; Funciones disponibles: char_a_morse

.include "morse_table.inc"
.include "chars_table.inc"

teclado  .equ    0xFF02
pantalla .equ    0xFF00

.globl  char_a_morse

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
	
	    leax    2,x                 ; SALTAMOS 2 BYTES (Letra + Nulo de .asciz)
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