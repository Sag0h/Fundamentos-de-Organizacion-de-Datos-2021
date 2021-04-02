program ej5;

type
	
	celular = record 
		cod:integer;
		marcaYNombre:string;
		descripcion:string;
		precio:real;
		minStock:integer;
		stock:integer;
	end;
	
	
	celulares = file of celular;

{a}
procedure crearArchivo(var a:celulares; var nombre:string);
var
	txt:Text;
	cel:celular;
begin
	write('Ingrese nombre del archivo a crear: ');
	readln(nombre);
	Assign(a, nombre);
	Assign(txt, 'celulares.txt');
	reset(txt);
	rewrite(a);
	while(not eof(txt))do begin
		with cel do begin
			readln(txt, cod, precio, marcaYNombre);
			readln(txt, stock, minStock, descripcion); 
		end;
		write(a, cel);
	end;
	close(txt);
	close(a);
	writeln('Archivo creado con exito!');
	readln();
end;

{b}
procedure listarStockMin(var a:celulares);
var
	cel:celular;
begin
	writeln('Celulares que tienen un stock menor al minimo: ');
	reset(a);
	while(not eof(a))do begin
		read(a,cel);
		if(cel.stock < cel.minStock)then
			with cel do writeln('Codigo de celular: ', cel.cod, ' - ', cel.marcaYNombre, ' $',precio:2:2,' ', descripcion, '.'); 
	end;
	close(a);
	readln();
end;

{c}
procedure listarDesc(var a:celulares);
var
	cad:string;
	cel:celular;
	x:integer;
	ok:boolean;
begin
	write('Ingrese texto para buscar en descripciones: ');
	readln(cad);
	reset(a);
	ok:=false;
	while(not eof(a))do begin
		read(a, cel);
		x:=pos(cad, cel.descripcion);
		if(x <> 0)then begin
			with cel do writeln('Codigo de celular: ', cel.cod, ' - ', cel.marcaYNombre, ' $',precio:2:2,' ', descripcion, '.');
			ok:=true;
		end;
	end;
	if(not ok)then
		writeln('No se encontro el texto ingresado en ninguna descripcion!');
	close(a);
	readln();
end;

{d}
procedure exportarATXT(var a:celulares; nombre:string);
var
	txt:Text;
	cel:celular;
begin
    writeln('Exportando de ', nombre, ' a celular.txt.');
	Assign(txt, 'celular.txt');
	rewrite(txt);
	reset(a);
	while(not eof(a))do begin
		read(a, cel);
		with cel do 
			writeln(txt, cod, ' ', marcaYNombre,' $',precio, ' ', descripcion, ' stock actual:', stock, ' stock minimo: ', minStock);  
	end;
	close(txt);
	writeln('Se exporto de ', nombre, ' a celular.txt con exito!');
	close(a);
	readln();
end;

{6.a}
procedure addCelulares(var a:celulares);
	procedure leerCelular(var cel:celular);
	begin
		write('Ingrese marca y nombre del celular: ');
		with cel do begin
			readln(marcaYNombre);
			write('Ingrese codigo del celular: ');
			readln(cod);
			write('Ingrese precio del celular: ');
			readln(precio);
			write('Ingrese descripcion del celular: ');
			readln(descripcion);
			write('Ingrese stock actual del celular: ');
			readln(stock);
			write('Ingrese stock minimo del celular: ');
			readln(minStock);
		end;
	end;
	
var
	cant:integer;
	cel:celular;
	i:integer;
begin
	write('Ingrese cantidad de celulares que va a agregar: ');
	readln(cant);
	if(cant > 0)then begin
		reset(a);
		seek(a, filesize(a));
		for i:= 1 to cant do begin
			leerCelular(cel);
			write(a, cel);
		end;
		close(a);
		writeln('Archivo modificado con exito!');
	end
	else begin
		writeln('Cantidad ingresada es invalida. Tiene que ser mayor a 0.');
		writeln('No se agrego ningun celular!');
	end;
	readln();
end;

{6.b}

procedure modificarStockCel(var a:celulares);
var
	nom:string;
	ok:boolean;
	cel:celular;
begin
	write('Ingrese marca y nombre del celular al cual quiere modificar el stock actual: ');
	readln(nom);
	reset(a);
	ok:=false;
	while(not eof(a))and(not ok) do begin
		read(a, cel);
		if(cel.marcaYNombre = nom)then begin
			ok:=true;
			write('Ingrese el nuevo valor de "Stock": ');
			readln(cel.stock);
			seek(a, filepos(a)-1);
			write(a, cel);
			writeln('Se cambio el valor de Stock!');
		end;
	end;
	close(a);
	if(not ok)then
		writeln('No se encontro el celular ingresado!');
	readln();
end;
	
{7.c}

procedure exportarSinStock(var a:celulares);
var
	cel:celular;
	sinStock:Text;
begin
	Assign(sinStock, 'SinStock.txt');
	rewrite(sinStock);
	reset(a);
	while(not eof(a))do begin
		read(a, cel);
		if(cel.stock = 0)then begin
			with cel do 
				writeln(sinStock, cod, ' ', marcaYNombre,' $',precio, ' ', descripcion, ' stock actual:', stock, ' stock minimo: ', minStock); 
		end;
	end;
	close(a);
	close(sinStock);
	writeln('Se copiaron los celulares sin Stock al texto "SinStock.txt"!');
	readln();
end;


{menu}

procedure DesplegarMenu(var a:celulares);
var
	opcion:integer;
	nombre:string;
begin
	nombre:= 'archivo';
	writeln('================ MENU ================');
	
	writeln('0. Salir');
	writeln('1. Crear Archivo a partir de celulares.txt.');
	writeln('2. Listar en pantalla los datos de aquellos celulares que tengan un stock menor al stock mínimo.');
	writeln('3. Listar en pantalla los celulares del archivo cuya descripción contenga una cadena de caracteres proporcionada por el usuario.');
	writeln('4. Exportar el archivo creado en la  a un archivo de texto denominado "celular.txt” con todos los celulares del mismo.');
	writeln('5. Añadir uno o más celulares al final del archivo con sus datos ingresados por teclado.');
	writeln('6. Modificar el stock de un celular.');
	writeln('7. Exportar de ', nombre,' a ”SinStock.txt” los celulares con stock 0.');
	writeln('======================================');
	write('Digite la operacion que desea: ');
	
	readln(opcion);
	writeln('======================================');
	case opcion of
		1: crearArchivo(a,nombre);
		2: listarStockMin(a);
		3: listarDesc(a);
		4: exportarATXT(a,nombre);
		5: addCelulares(a);
		6: modificarStockCel(a);
		7: exportarSinStock(a); 
		0: writeln('Fin del programa');
		else begin 
			writeln('Opcion Incorrecta - Ingrese una correcta()');
			DesplegarMenu(a);
		end;
	end;
	if(opcion <> 0)then 
		DesplegarMenu(a);
end;









{main}
var
	a:celulares;
begin
	DesplegarMenu(a);
end.
