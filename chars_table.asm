	.module chars_table

.include "chars_table.inc"

chars_table:        
    .asciz "A"
    .asciz "B"
    .asciz "C"
    .asciz "D"
    .asciz "E"
    .asciz "F"
    .asciz "G"
    .asciz "H"
    .asciz "I"
    .asciz "J"
    .asciz "K"
    .asciz "L"
    .asciz "M"
    .asciz "N"
    .asciz "O"
    .asciz "P"
    .asciz "Q"
    .asciz "R"
    .asciz "S"
    .asciz "T"
    .asciz "U"
    .asciz "V"
    .asciz "W"
    .asciz "X"
    .asciz "Y"
    .asciz "Z"
    .asciz "0"
    .asciz "1"
    .asciz "2"
    .asciz "3"
    .asciz "4"
    .asciz "5"
    .asciz "6"
    .asciz "7"
    .asciz "8"
    .asciz "9"	

chars_table_Char: 		.byte		26
chars_table_Number: 	.byte		10
chars_table_Total: 		.byte		36

	;; SEPARACION ENTRE LETRAS  :  1 espacio
	;; SEPARACION ENTRE PALABRAS:  2 espacios
