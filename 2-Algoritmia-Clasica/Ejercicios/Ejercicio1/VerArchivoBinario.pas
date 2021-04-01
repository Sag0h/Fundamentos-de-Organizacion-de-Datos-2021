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
end;


procedure menu_opciones(var a:archivo);
var
	opcion: integer;
begin
	writeln('---------- Menu ----------');
	writeln('Ingrese una opcion: ');
	writeln('1. Ver un archivo binario. ');
	writeln('2. Exit.');
	writeln('--------------------------');
	readln(opcion);
	case opcion of 
		1: ver_archivo_binario(a);
		2: halt(0);
	else 
		begin
			writeln('Ingreso una opcion invalida.');
			menu_opciones(a);
		end;
	menu_opciones(a);
	end;
end;

{programa principal}

var
	a:archivo;
begin

	menu_opciones(a);
	readln();
end.
