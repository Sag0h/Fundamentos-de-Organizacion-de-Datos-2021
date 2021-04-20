{Realizar un algoritmo que cree un archivo de números enteros no ordenados y permita
incorporar datos al archivo. Los números son ingresados desde teclado. El nombre del
archivo debe ser proporcionado por el usuario desde teclado. La carga finaliza cuando
se ingrese el número 30000, que no debe incorporarse al archivo.}

program ej1;

type

archivo = file of integer;


var
	num:integer;
	a_numeros : archivo;
	nombre : string;
begin
	write('Ingrese nombre del archivo a crear: ');
	readln(nombre);
	Assign(a_numeros, '/home/sagoh/Escritorio/FOD/Practica/p1e1/'+nombre);
	rewrite(a_numeros);
	writeln('=== Ingrese numeros enteros, finalice la lectura ingresando el numero 30000 ===');
	write('Ingrese un numero entero: ');
	readln(num);
	while(num <> 30000)do begin
		write(a_numeros, num);
		write('Ingrese un numero entero: ');
		readln(num);
	end;
	close(a_numeros);
end.
