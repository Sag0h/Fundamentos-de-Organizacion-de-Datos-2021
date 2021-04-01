program ver;

type
	alumno = record
		cod:integer;
		ape:string;
		nombre:string;
		cantA_C:integer;
		cantA_F:integer;
	end;

	materia = record
		cod:integer;
		estado:string; 
		nombre:string;
	end;

	archivo = file of alumno;
	detalle = file of materia;
	
{=================================================================================================================================================}
	
procedure ver_archivo_maestro(var a:archivo);
var
	data:alumno;
begin
	assign(a, 'alumnos');
	reset(a);
	while(not EOF(a))do begin
		read(a,data);
		writeln('alumno: ', data.cod, ' - ', data.nombre, ' ', data.ape,' - aprobadas solo cursada: ', data.cantA_C, ' - aprobadas con final: ', data.cantA_F, '.'); {cambiar dependiendo de los campos}
	end;
	close(a);
	readln();
end;

{=================================================================================================================================================}
	
procedure ver_archivo_detalle(var a:detalle);
var
	data:materia;
begin
	assign(a, 'detalle');
	reset(a);
	while(not EOF(a))do begin
		read(a,data);
		writeln('Codigo de alumno: ', data.cod, ' - Materia: ', data.nombre, ' Aprobo ', data.estado, '.');
	end;
	close(a);
	readln();
end;

{=================================================================================================================================================}

procedure RandomData(var a:Text);
var
	datos:alumno;
	cod:integer;
	strcod:string;
	nombre:string;
begin
	write('Ingrese nombre del archivo a generar: ');
	readln(nombre);
	assign(a, nombre+'.txt');
	rewrite(a);
	writeln('>>>>>>>>>>>>>> INGRESAR LA INFORMACION ORDENADA POR CODIGO <<<<<<<<<<<<<<<<');
	write('Ingrese codigo: ');
	readln(cod); 
	while(cod <> 0)do begin
		datos.cod := cod;
		Str(cod,strcod);
		datos.ape := 'ApellidoRandom'+strcod;
		datos.nombre := 'NombreRandom'+strcod;
		datos.cantA_C := 0;
		datos.cantA_F := 0;
		writeln(a, datos.ape); 
		writeln(a, datos.nombre);
		writeln(a,datos.cod,' ', datos.cantA_C,' ',datos.cantA_F);
		
		write('Ingrese codigo: ');
		readln(cod); 
	end;
	close(a);
end;

{=================================================================================================================================================}

procedure RandomDataDet(var a:Text);
var
	datos:materia;
	cod:integer;
	strcod:string;
	nombre:string;
	aux:integer;
begin
	write('Ingrese nombre del archivo detalle a generar: ');
	readln(nombre);
	assign(a, nombre+'.txt');
	rewrite(a);
	writeln('>>>>>>>>>>>>>> INGRESAR LA INFORMACION ORDENADA POR CODIGO <<<<<<<<<<<<<<<<');
	write('Ingrese codigo de Alumno: ');
	readln(cod); 
	while(cod <> 0)do begin
		datos.cod := cod;
		
		cod := Random(15);
		Str(cod,strcod);
		datos.nombre := 'materiaRandom'+strcod;
		
		aux := Random(2);
		if(aux = 1)then begin {si es 1 entonces solo aprobo cursada}
			datos.estado := 'cursada';
		end
		else begin
			datos.estado := 'final';
		end;
		writeln(a,datos.cod,' ',datos.estado);
		writeln(a, datos.nombre);
		write('Ingrese codigo de Alumno: ');
		readln(cod); 
	end;
	close(a);
end;

{=================================================================================================================================================}

procedure menu_opciones(var a:Text);
var
	opcion: integer;
	b: Text;
	c: detalle;
	d: archivo;
begin
	writeln('---------- Menu ----------');
	writeln('Ingrese una opcion: ');
	writeln('1. Crear un archivo .txt con datos aleatorios.');
	writeln('2. Ver archivo maestro.');
	writeln('3. Ver archivo detalle.');
	writeln('4. Crear archivo detalle.txt con datos aleatorios.');
	writeln('0. Exit.');
	writeln('--------------------------');
	write('Ingrese opcion: ');
	readln(opcion);
	case opcion of 
		1: RandomData(a);
		2: ver_archivo_maestro(d);
		3: ver_archivo_detalle(c);
		4: RandomDataDet(b);
		0: halt(0);
	else 
		begin
			writeln('Ingreso una opcion invalida.');
			menu_opciones(a);
		end;
	end;
	menu_opciones(a);
end;

{=================================================================================================================================================}

{programa principal}

var
	a:Text;
begin

	menu_opciones(a);
	readln();
end.
