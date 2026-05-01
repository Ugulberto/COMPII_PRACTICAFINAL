		.module  stringH

; Módulo stringH
; Creado por: David Blanco de la Iglesia
; Funciones disponibles: strcmp, is_alphanum

teclado  .equ    0xFF02
pantalla .equ    0xFF00

.globl  strcmp
.globl	is_alphanum

carga_b:	.word 0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Función strcmp: compara dos cadenas de caracteres.                 ;
;                                                                    ;
; Entrada:                                                           ;
;   - X: Dirección inicial de la primera cadena.                     ;
;   - Y: Dirección inicial de la segunda cadena.                     ;
;                                                                    ;
; Salida:                                                            ;
;   - B: 1 si las cadenas son iguales, 0 si no lo son.               ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

strcmp:
	pshs	a,x,y
	
	strcmp_bucle:
		lda ,x+
		ldb ,y+
		stb carga_b
		cmpa carga_b
		bne strcmp_distintos
		cmpa '\0
		beq strcmp_iguales
		bra strcmp_bucle
		
	strcmp_iguales:
		ldb		#1
		bra		strcmp_acabar
	
	strcmp_distintos:
		ldb		#0
		bra		strcmp_acabar
	
	strcmp_acabar:
		puls	a,x,y	; No uso register_pull pues sobreescribe el valor del registro B, usado para la salida.
		rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Función is_alphanum: comprueba si un carácter es letra o número    ;
;                                                                    ;
; Entrada:                                                           ;
;   - A: Caracter a comprobar.                                       ;
;                                                                    ;
; Salida:                                                            ;
;   - B: 1 si es alfanumérico, 0 si no lo es.                        ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

is_alphanum:
    ; 0 - 9
    cmpa    #'0            
    blo     no_es_alfanumerico           
    cmpa    #'9            
    bls     es_alfanumerico      

    ; A - Z
    cmpa    #'A     
    blo     no_es_alfanumerico   
    cmpa    #'Z   
    bls     es_alfanumerico   

    ; a - z
    cmpa    #'a        
    blo     no_es_alfanumerico  
    cmpa    #'z        
    bls     es_alfanumerico   

	no_es_alfanumerico:
		ldb		#0
	    rts                     ; devuelve B = 0

	es_alfanumerico:
	    ldb     #1              
	    rts                     ; devuelve B = 1