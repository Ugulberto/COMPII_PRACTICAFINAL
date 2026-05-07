	.module chars_table

.include "chars_table.inc"

chars_table:  
    .ascii "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"      

chars_table_Char: 		.byte		26
chars_table_Number: 	.byte		10
chars_table_Total: 		.byte		36

