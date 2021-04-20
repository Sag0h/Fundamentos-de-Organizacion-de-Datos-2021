{Realizar un algoritmo, que utilizando el archivo de números enteros no ordenados
creados en el ejercicio 1, informe por pantalla cantidad de números menores a 1500 y
el promedio de los números ingresados. El nombre del archivo a procesar debe ser
proporcionado por el usuario una única vez. Además, el algoritmo deberá listar el
contenido del archivo en pantalla.}

program ej2;

type

	archivo = file of integer;
	
var
	cant:integer;
	num:integer;
	a:archivo;
	nombre:string;
begin
	cant:=0;
	write('Ingrese la ruta y el archivo a procesar: ');
	readln(nombre);
	Assign(a, nombre);
	reset(a);
	while(not eof(a))do begin
		read(a,num);
		if(num < 1500)then
			cant:= cant + 1;
		writeln('=== ', num, ' ===');
	end;
	close(a);
	writeln('La cantidad de numeros menores a 1500 es de: ', cant);
	
	
end.

