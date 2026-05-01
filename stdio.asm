.module  stdio

; Módulo stdio
; Creado por: David Blanco de la Iglesia
; Funciones disponibles: printStr, printBreak, inputStr, strcmp

pantalla .equ    0xFF00
teclado  .equ    0xFF02

.globl  printStr
.globl  printnStr
.globl  printBreak
.globl  inputStr
.globl	printInt
.globl  printHex
.globl  inputAlphanum

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Función printStr: imprime una cadena por pantalla                                                                     ;
; Entrada: antes de ejecutar la función se debe cargar la direccion de inicio de la cadena a imprimir en el registro x  ;
; Salida: ninguna                                                                                                       ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

printStr:
	pshs	a,b,x,y
	
    printStr_bucle:
       	lda     ,x+
        beq     printStr_acabar
        sta     pantalla
        bra     printStr_bucle
        
    printStr_acabar:
    	puls    a,b,x,y
        rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Función printnStr: imprime una cadena de longitud n por pantalla hasta encontrar un espacio en blanco,     ;
; llegar a los n caracteres o encontrar un \0.                                                               ;
; Entrada: antes de ejecutar la función se debe cargar la direccion                                          ;
; de inicio de la cadena a imprimir en el registro x y el tamaño de la cadena (incluido \0) en el registro B ;
; Salida: ninguna                                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

printnStr:
    pshs    a,b,x

    printnStr_bucle:
        tstb
        beq     printnStr_acabar   ; Si B == 0, terminar

        lda     ,x+
        beq     printnStr_acabar   ; Fin de cadena

        cmpa    #32
        beq     printnStr_acabar   ; Espacio

        sta     pantalla

        decb
        bra     printnStr_bucle

    printnStr_acabar:
        puls    a,b,x
        rts



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Función printBreak: imprime un salto de línea por pantalla  ;
; Entrada: ninguna                                            ;
; Salida: ninguna                                             ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

printBreak:
	pshs	a
    lda     #'\n
    sta     pantalla
    puls    a
    rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Función inputStr: lee la cadena de entrada hasta llegar a un salto de línea.                  ;
; Entrada: se debe cargar en el registro x la dirección de inicio de la cadena donde cargarlo.  ;
; Salida: ninguna                                                                               ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

inputStr:
	pshs	a,x
	
    inputStr_bucle:
        lda     teclado
        cmpa    #'\n
        beq     inputStr_fin
        sta     ,x+
        bra     inputStr_bucle
        
    inputStr_fin:
        lda     #'\0
        sta     ,x+
        puls    a,x
        rts

; Función de stringH. Las bibliotecas como stdio no deberían tener dependencias para poder usarse en otros archivos.
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Función inputAlphanum: lee la cadena de entrada hasta llegar a un salto de línea, o hasta     ;
; llegar a un caracter no alfanumerico de lo cual se informara con un valor de retorno en B.    ;
; Entrada: se debe cargar en el registro x la dirección de inicio de la cadena donde cargarlo.  ;
; Salida: Se cargará 0 en B si se salió del bucle por llegar a un salto de línea o 1 si se      ;
; salio por haberse introducido un caracter NO alfanumerico.                                    ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

inputAlphanum:
	pshs	a,x
	
    inputAlphanum_bucle:
        lda     teclado

        cmpa    #'\n
        beq     inputAlphanum_fin_0

        cmpa    #' 
        beq     inputAlphanum_seguir

        jsr     is_alphanum
        cmpb    #0
        beq     inputAlphanum_fin_1

        inputAlphanum_seguir:
            sta     ,x+
            bra     inputAlphanum_bucle

    inputAlphanum_fin_0:
        ldb     #0
        bra     inputAlphanum_fin
    
    inputAlphanum_fin_1:
        ldb     #1

    inputAlphanum_fin:
        lda     #'\0
        sta     ,x+
        puls    a,x
        rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Función printHex: imprime un número de 8 bits (0-255) en hexadecimal  ;
; Entrada: el número a imprimir debe estar cargado en el registro A     ;
; Salida: ninguna                                                       ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

printHex:
    pshs	a,b,x,y
    tfr     a,b ; Conservo el valor de a en b

    lsra    
    lsra    
    lsra    
    lsra    ; 4 desplazamientos a la derecha (1 número en hexadecimal corresponde a 4 bits)

    ; Ahora tengo la cifra más significativa en a

    bsr     hexToAscii

    tfr     b,a
    anda    #0x0F     ; Solo me quedo con los 4 bits de abajo

    bsr     hexToAscii

    puls    a,b,x,y
    rts

; Subrutina auxiliar que imprime un dígito hexadecimal por pantalla
hexToAscii:
    adda    #'0 ; 30 = 0 ... 39 = 9
    cmpa    #'9 ; es mayor que 39? (que 9 en caracter)

    bls     hexOut ; Si no simplemente lo puedo imprimir

    adda    #7 ; Si lo es sumo 7 para que 10 = A, 11 = B, etc.

    hexOut:
        sta     pantalla
    
    rts ; Vuelvo

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Función printInt: imprime un número de 8 bits (0-255) en decimal      ;
; Entrada: el número a imprimir debe estar cargado en el registro A     ;
; Salida: ninguna                                                       ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

printInt:
    pshs	a,b,x,y

    ; Procesamos las centenas
    ldb     #0          ; Contador de centenas

	printInt_100:
    	cmpa    #100
    	blo     printInt_disp100 ; Si A < 100, terminamos de contar
    	suba    #100
    	incb
    	bra     printInt_100

	printInt_disp100:
    	pshs    a           ; Guardar el resto
    	tfr     b,a         ; Pasar centenas a A
        cmpa    #0
        beq     printInt_noCentena
    	adda    #'0        ; Convertir a ASCII (0 -> '0')
    	sta     pantalla    ; Imprimir

        printInt_noCentena:

    	puls    a           ; Recuperar el resto

    	; Procesamos las decenas
    	ldb     #0          ; Contador de decenas
		printInt_10:
    	cmpa    #10
    	blo     printInt_disp10 ; Si A < 10, terminar decenas
    	suba    #10
    	incb
    	bra     printInt_10

	printInt_disp10:
    	pshs    a           
    	tfr     b,a      
        cmpa    #0
        beq     printInt_noDecena  
    	adda    #'0     

    	sta     pantalla

        printInt_noDecena:

    	puls    a           ; Recuperar unidades

    	; Procesamos las unidades
    	adda    #'0       ; En A quedan las unidades
    	sta     pantalla    ; Imprimir

    puls    a,b,x,y
    rts
			


            

