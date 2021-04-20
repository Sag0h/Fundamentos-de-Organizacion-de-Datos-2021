program ver;

type
	venta = record
		cod:integer;
		nombre:string;
		monto:real;
	end;

	archivo = file of venta;
	
procedure ver_archivo_binario(var a:archivo);
var
	file_name:string;
	data:venta;
begin
	write('Ingrese el nombre del archivo a visualizar: ');
	readln(file_name);
	assign(a, file_name);
	reset(a);
	while(not EOF(a))do begin
		read(a,data);
		writeln(data.cod, ' ', data.nombre, ' ', data.monto:2:2, '.'); {cambiar dependiendo de los campos}
	end;
	close(a);
	readln();
end;


	
procedure RandomData(var a:archivo);
var
	datos:venta;
	cod:integer;
	strcod:string;
	nombre:string;
begin
	write('Ingrese nombre del archivo a generar: ');
	readln(nombre);
	assign(a, nombre);
	rewrite(a);
	writeln('>>>>>>>>>>>>>> INGRESAR LA INFORMACION ORDENADA POR CODIGO <<<<<<<<<<<<<<<<');
	write('Ingrese codigo: ');
	readln(cod); 
	while(cod <> 0)do begin
		datos.cod := cod;
		datos.monto := Random(501);
		Str(cod,strcod);
		datos.nombre := 'nombreGenerico'+strcod;
		
		write(a, datos);
		write('Ingrese codigo: ');
		readln(cod); 
	end;
	close(a);
end;


procedure menu_opciones(var a:archivo);
var
	opcion: integer;
begin
	writeln('---------- Menu ----------');
	writeln('Ingrese una opcion: ');
	writeln('1. Crear un archivo con datos aleatorios.');
	writeln('2. Ver un archivo binario.');
	writeln('3. Exit.');
	writeln('--------------------------');
	readln(opcion);
	case opcion of 
		1: RandomData(a);
		2: ver_archivo_binario(a);
		3: halt(0);
	else 
		begin
			writeln('Ingreso una opcion invalida.');
			menu_opciones(a);
		end;
	end;
	menu_opciones(a);
end;

{programa principal}

var
	a:archivo;
begin

	menu_opciones(a);
	readln();
end.
