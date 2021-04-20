program ej7;

type
	novela=record
		cod:integer;
		nombre:string;
		genero:string;
		precio:real;
	end;
	
	novelas = file of novela;

procedure crearArchivo(var a:novelas);
var
	txt:Text;
	nombre:string;
	nov:novela;
begin
	write('Ingrese nombre del archivo a crear: ');
	readln(nombre);
	Assign(a, '/home/sagoh/Escritorio/FOD/Practica/p1e7/'+nombre);
	Assign(txt, '/home/sagoh/Escritorio/FOD/Practica/p1e7/novelas.txt');
	reset(txt);
	rewrite(a);
	while(not eof(txt))do begin
		with nov do begin
			readln(txt, cod, precio, genero);
			readln(txt, nombre);
		end;
		write(a, nov);
	end;
	close(txt);
	close(a);
	readln();
end;

procedure leerNovela(var nov:novela);
begin
	with nov do begin
		write('Ingrese codigo de la novela: ');
		readln(cod);
		write('Ingrese nombre de la novela: ');
		readln(nombre);
		write('Ingrese genero de la novela: ');
		readln(genero);
		write('Ingrese precio de la novela: ');
		readln(precio);
	end;
end;

procedure agregarNovela(var a:novelas);
var
	nov:novela;
begin
	leerNovela(nov);
	reset(a);
	seek(a, filesize(a));
	write(a, nov);
	close(a);
	writeln('Se agrego la novela ingresada con exito!');
	readln();
end;

procedure menuModificacion(var nov:novela);
	procedure modificarNombre(var nombre:string);
	begin
		writeln('------------- Modificacion de Nombre -------------');
		write('Ingrese nuevo nombre de la novela: ');
		readln(nombre);
		writeln('Se modifico el nombre de la novela!');
	end;

	procedure modificarGenero(var genero:string);
	begin
		writeln('------------- Modificacion de Genero -------------');
		write('Ingrese nuevo genero de la novela: ');
		readln(genero);
		writeln('Se modifico el genero de la novela!');
	end;

	procedure modificarPrecio(var p:real);
	begin
		writeln('------------- Modificacion de Precio -------------');
		write('Ingrese nuevo precio de la novela: ');
		readln(p);
		writeln('Se modifico el precio de la novela!');
	end;

	procedure modificarCodigo(var c:integer);
	begin
		writeln('------------- Modificacion de Codigo de la Novela -------------');
		write('Ingrese nuevo Codigo de la novela: ');
		readln(c);
		writeln('Se modifico el codigo de la novela!');
	end;

var
	opcion:integer;
begin
	writeln('------------- MENU DE MODIFICACIONES -------------');
	writeln('Datos Actuales: ');
	with nov do 
		writeln('(Nombre: ', nombre, ' genero: ', genero, ' precio: ', precio:2:2, ' codigo: ', cod, ')');
	writeln('1. Modificar nombre.');
	writeln('2. Modificar genero.');
	writeln('3. Modificar precio.');
	writeln('4. Modificar codigo.');
	writeln('5. Salir del menu de modificaciones.');
	write('Ingrese su opcion: ');
	readln(opcion);
	case opcion of
		1: modificarNombre(nov.nombre);
		2: modificarGenero(nov.genero);
		3: modificarPrecio(nov.precio);
		4: modificarCodigo(nov.cod);
		5: writeln('Usted salio del menu de modificaciones.');
		else begin 
			writeln('Opcion Incorrecta - Ingrese una correcta()');
			menuModificacion(nov);
		end;
	end;
	if(opcion <> 5)then
		menuModificacion(nov);
end;

procedure modificarNovela(var a:novelas);
var
	ok:boolean;
	nov:novela;
	cod:integer;
begin
	ok:=false;
	write('Ingrese codigo de la novela que quiere modificar: ');
	readln(cod);
	reset(a);
	while(not eof(a))and(not ok)do begin
		read(a, nov);
		if(nov.cod = cod)then begin
			ok:=true;
			menuModificacion(nov);
			seek(a, filepos(a)-1);
			write(a, nov);
			writeln('Se modifico la novela de codigo ', cod, ' correctamente!');
		end;
	end;
	close(a);
	if(not ok)then
		writeln('No se encontro el codigo de novela ingresado!');
end;

procedure DesplegarMenu(var a:novelas);
var
	opcion:integer;
begin
	writeln('==========  MENU  ==========');
	writeln('1. Agregar novela.');
	writeln('2. Modificar novela existente.');
	writeln('3. Salir.');
	write('Ingrese su opcion: ');
	readln(opcion);
	writeln(' ');
	case opcion of
		1: agregarNovela(a);
		2: modificarNovela(a);
		3: begin
			write('Fin del programa.');
			readln();
		end;
		else begin 
			writeln('Opcion Incorrecta - Ingrese una correcta()');
			DesplegarMenu(a);
		end;
	end;
	
	if(opcion <> 3)then
		DesplegarMenu(a);
end;

var 
	Archivo_de_novelas:novelas;
begin
	crearArchivo(archivo_de_novelas);
	DesplegarMenu(archivo_de_novelas);
end.
