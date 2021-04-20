program ejer2;

const valor_alto = 9999;

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
		nombre:string; {de la materia}
	end;
	
	archivo = file of alumno;
	a_det = file of materia;


{===========================================================================================================================================}
	
{a}

procedure crearMaestro(var a:archivo);
var
	txt:Text;
	datos:alumno;
begin
	assign(a, 'alumnos');
	assign(txt, 'alumnos.txt');
	reset(txt);
	rewrite(a);
	while(not EOF(txt))do begin
		with datos do begin
			readln(txt, ape);
			readln(txt, nombre);
			readln(txt, cod, cantA_C, cantA_F);
		end;
		write(a, datos);
	end;
	close(a);
	close(txt);
end;
	
{===========================================================================================================================================}

{b}

procedure crearDetalle(var det:a_det);
var
	txt:Text;
	datos:materia;
begin
	assign(det, 'detalle');
	assign(txt, 'detalle.txt');
	reset(txt);
	rewrite(det);
	while(not EOF(txt))do begin
		with datos do begin
			readln(txt, cod, estado);
			readln(txt, nombre);
		end;
		write(det, datos);
	end;
	close(det);
	close(txt);
end;

{===========================================================================================================================================}

procedure listarMaestro(var a:archivo);
var
	txt:Text;
	datos:alumno;
begin
	assign(txt, 'reporteAlumnos.txt');
	assign(a, 'alumnos');
	rewrite(txt);
	reset(a);
	while(not EOF(a))do begin
		read(a,datos);
		writeln(txt, 'Nombre: ', datos.nombre, ' - Apellido: ', datos.ape, ' - Codigo de Alumno: ', datos.cod, ' - Aprobadas solo cursada: ', datos.cantA_C, ' - Aprobadas con final: ', datos.cantA_F, '.');
	end;
	close(a);
	close(txt);
end;

{===========================================================================================================================================}

procedure listarDetalle(var a:a_det);
var
	txt:Text;
	datos:materia;
begin
	assign(txt, 'reporteDetalle.txt');
	assign(a, 'detalle');
	rewrite(txt);
	reset(a);
	while(not EOF(a))do begin
		read(a,datos);
		with datos do
		 	writeln(txt, 'Codigo de alumno: ', cod, ' - Materia: ', nombre, ' Aprobo ', estado, '.');		
	end;
	close(a);
	close(txt);
end;

{===========================================================================================================================================}

procedure leer(var a:a_det; var datos:materia);
begin
	if(not eof(a))then
		read(a, datos)
	else
		datos.cod := valor_alto;
end;

	
procedure ActualizarMaestro(var a:archivo; var detalle:a_det);
var
	datos:materia;
	datosMaestro:alumno;
	cod_act:integer;
begin
	assign(detalle, 'detalle');
	assign(a, 'alumnos');
	reset(detalle);
	reset(a);
	
	leer(detalle,datos);
	while(datos.cod <> valor_alto)do begin
		
		read(a, datosMaestro);
		while(datosMaestro.cod <> datos.cod)do
			read(a, datosMaestro);
		cod_act:=datos.cod;	
		
		while(datos.cod = cod_act) do begin
			if(datos.estado = 'final')then
				datosMaestro.cantA_F := datosMaestro.cantA_F + 1
			else
				datosMaestro.cantA_C := datosMaestro.cantA_C + 1;
			leer(detalle, datos);
		end;
		
		seek(a, filepos(a)-1);
		write(a, datosMaestro);
		
	end;
	close(a);
	close(detalle);
end;
	
{===========================================================================================================================================}

procedure ListarNoFinal(var a:archivo);
var
	txt:Text;
	datos:alumno;
begin
	assign(a, 'alumnos');
	assign(txt, 'cursadas.txt');
	rewrite(txt);
	reset(a);
	while(not eof(a))do begin
		read(a, datos);
		if(datos.cantA_C > 4)then
			with datos do 
				writeln(txt, 'Nombre: ', datos.nombre, ' - Apellido: ', datos.ape, ' - Codigo de Alumno: ', datos.cod, ' - Aprobadas solo cursada: ', datos.cantA_C, ' - Aprobadas con final: ', datos.cantA_F, '.');
	end;
	close(a);
	close(txt);
end;

{===========================================================================================================================================}
	
{programa principal}	

var
	maestro:archivo;
	detalle:a_det;
begin
	crearMaestro(maestro);
	crearDetalle(detalle);
	listarMaestro(maestro);
	listarDetalle(detalle);
	ActualizarMaestro(maestro,detalle);
	ListarNoFinal(maestro);
	readln();
end.
