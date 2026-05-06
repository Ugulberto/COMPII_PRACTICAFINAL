	.module tabla_morse

	.include "morse_table.inc"

tabla_morse:		
	.asciz ".-   "  ; A
	.asciz "-... "  ; B
	.asciz "-.-. "  ; C
	.asciz "-..  "  ; D
	.asciz ".    "  ; E
	.asciz "..-. "  ; F
	.asciz "--.  "  ; G
	.asciz ".... "  ; H
	.asciz "..   "  ; I
	.asciz ".--- "  ; J
	.asciz "-.-  "  ; K
	.asciz ".-.. "  ; L
	.asciz "--   "  ; M
	.asciz "-.   "  ; N	
	.asciz "---  "  ; O	
	.asciz ".--. "  ; P
	.asciz "--.- "  ; Q
	.asciz ".-.  "  ; R
	.asciz "...  "  ; S
	.asciz "-    "  ; T
	.asciz "..-  "  ; U
	.asciz "...- "  ; V	
	.asciz ".--  "  ; W
	.asciz "-..- "  ; X
	.asciz "-.-- "  ; Y
	.asciz "--.. "  ; Z
	.asciz "-----"  ; 0	
	.asciz ".----"  ; 1	
	.asciz "..---"  ; 2	
	.asciz "...--"  ; 3	
	.asciz "....-"  ; 4	
	.asciz "....."  ; 5	
	.asciz "-...."  ; 6	
	.asciz "--..."  ; 7	
	.asciz "---.."  ; 8	
	.asciz "----."  ; 9		

tabla_morse_Char: 		.byte		26
tabla_morse_Number: 		.byte		10
tabla_morse_Total: 		.byte		36

	;; SEPARACION ENTRE LETRAS  :  1 espacio
	;; SEPARACION ENTRE PALABRAS:  2 espacios
