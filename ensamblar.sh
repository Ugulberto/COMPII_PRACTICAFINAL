# Los comandos "ensambla" y "limpia" son los utilizados durante las clases de prácticas de computadores II.
# Se pueden instalar desde studium.
ensambla morse libraries/stdio libraries/stringH libraries/charMorse tables/chars_table tables/morse_table submenu1/mostrar_tabla submenu2/caracter_a_caracter submenu2/palabra_a_palabra submenu2/linea_a_linea submenu3/caracter_a_caracter submenu3/palabra_a_palabra submenu3/linea_a_linea

limpia > /dev/null 2>&1
for dir in submenu1 submenu2 submenu3 libraries tables; do
    (cd "$dir" && limpia > /dev/null 2>&1)
done
