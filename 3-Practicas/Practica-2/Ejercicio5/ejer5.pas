program ejer5;
const
	dimF = 2;
	VALOR_ALTO = 9999;
type 
	
	direccion = record
		calle : string[20];
		nro : integer;
		piso : integer;
		depto : string[4];
		ciudad : string[20];
	end;
	
	nacimiento = record
		nro_partida_nacimiento : integer;
		nombre : string[25];
		apellido : string[25];
		dir : direccion;
		
		matricula_medico : integer;
		
		nombre_madre : string[25];
		apellido_madre: string[25];
		dni_madre : integer;
		
		nombre_padre : string[25];
		apellido_padre : string[25];
		dni_padre : integer;
	end;


	fallecimiento = record
		nro_partida_nacimiento : integer;
		dni : integer;
		nombre : string[25];
		apellido : string[25];
		
		matricula_medico_deceso : integer;
		
		fecha_deceso : string[10];
		hora_deceso : string[5];
		lugar_deceso : string[20];
	end;
	
	archivo_nacimientos = file of nacimiento;
	
	archivo_fallecimientos = file of fallecimiento;
	
	arreglo_nacimientos = array [1..dimF] of archivo_nacimientos;
	arreglo_reg_nacimientos = array [1.. dimF] of nacimiento;
	
	arreglo_fallecimientos = array [1..dimF] of archivo_fallecimientos;
	arreglo_reg_fallecimientos = array [1..dimF] of fallecimiento;

	
	informacion = record
		nro_partida_nacimiento : integer;
		dni : integer;
		nombre : string[25];
		apellido : string[25];
		dir : direccion;
		matricula_medico : integer;
		
		nombre_madre : string[25];
		apellido_madre: string[25];
		dni_madre : integer;
		
		nombre_padre : string[25];
		apellido_padre : string[25];
		dni_padre : integer;
		
		fallecio: boolean;
		
		matricula_medico_deceso : integer;
		
		fecha_deceso : string[10];
		hora_deceso : string[5];
		lugar_deceso : string[20];
		direc : direccion;
	end;

	archivo = file of informacion;
	
{=============================================================================================================================================================}
	
procedure leer_detalles_nacimientos(var v:arreglo_nacimientos);

procedure leer_nacimiento(var datos:nacimiento);
begin
	with datos do begin
		write('Ingrese numero de partida de nacimiento: ');
		readln(nro_partida_nacimiento);
		if(nro_partida_nacimiento <> 0)then begin
			write('Ingrese nombre: ');
			readln(nombre);
			write('Ingrese apellido: ');
			readln(apellido);
			writeln();
			writeln('Direccion: ');
			write('Ingrese calle: ');
			readln(dir.calle);
			write('Ingrese nro de casa: ');
			readln(dir.nro);
			write('Ingrese piso: ');
			readln(dir.piso);
			write('Ingrese depto: ');
			readln(dir.depto);
			write('Ingrese ciudad: ');
			readln(dir.ciudad);
			writeln();
			write('Ingrese numero de matricula del medico: ');
			readln(matricula_medico);
			writeln();
			writeln('Datos de los padres: ');
			write('Ingrese nombre de la madre: ');
			readln(nombre_madre);
			write('Ingrese apellido de la madre: ');
			readln(apellido_madre);
			write('Ingrese dni de la madre: ');
			readln(dni_madre);
			writeln();
			write('Ingrese nombre del padre: ');
			readln(nombre_padre);
			write('Ingrese apellido del padre: ');
			readln(apellido_padre);
			write('Ingrese dni del padre: ');
			readln(dni_padre);
			writeln();
		end;
	end;
end;

var
	i:integer;
	icast:string;
	datos:nacimiento;
begin
	writeln(' - - - - - - - - ARCHIVOS DETALLE DE NACIMIENTOS - - - - - - - -');
	writeln();
	for i:=1 to dimF do begin
		writeln('Archivo detalle de nacimiento nro ', i,': ');
		Str(i, icast);
		assign(v[i], 'detalle-nacimiento-'+icast);
		rewrite(v[i]);
		leer_nacimiento(datos);
		while(datos.nro_partida_nacimiento <> 0)do begin
			write(v[i], datos);
			leer_nacimiento(datos);
		end;
		close(v[i]);
	end;
end;

{=============================================================================================================================================================}	
	
procedure leer_detalles_fallecimientos(var v:arreglo_fallecimientos);

procedure leer_deceso(var datos:fallecimiento);
begin
	with datos do begin
		write('Ingrese numero de partida de nacimiento: ');
		readln(nro_partida_nacimiento);
		if(nro_partida_nacimiento <> 0)then begin
			write('Ingrese nombre: ');
			readln(nombre);
			write('Ingrese apellido: ');
			readln(apellido);
			write('Ingrese DNI: ');
			readln(dni);
			write('Ingrese numero de matricula del medico que firmo el deceso: ');
			readln(matricula_medico_deceso);
			writeln();
			writeln('Datos del deceso: ');
			write('Ingrese fecha del deceso (DD/MM/AAAA): ');
			readln(fecha_deceso);
			write('Ingrese hora del deceso "formato -> (22:59)": ');
			readln(hora_deceso);
			write('Ingrese lugar de deceso: ');
			readln(lugar_deceso);
			writeln();
		end;
	end;
end;


var
	i:integer;
	icast:string;
	datos:fallecimiento;
begin
	writeln(' - - - - - - - - ARCHIVOS DETALLE DE FALLECIMIENTOS - - - - - - - -');
	writeln();
	for i:=1 to dimF do begin
		writeln('Archivo detalle de fallecimiento nro ', i,': ');
		Str(i, icast);
		assign(v[i], 'detalle-fallecimiento-'+icast);
		rewrite(v[i]);
		leer_deceso(datos);
		while(datos.nro_partida_nacimiento <> 0)do begin
			write(v[i], datos);
			leer_deceso(datos);
		end;
		close(v[i]);
	end;
end;

{=============================================================================================================================================================}

procedure merge_archivos(var a:archivo; var v_deta_nacim:arreglo_nacimientos; var v_deta_fall:arreglo_fallecimientos);

{leer}

procedure leer_naci(var archivo:archivo_nacimientos; var dato:nacimiento);
begin
    if (not eof( archivo ))then 
		read (archivo, dato)
    else 
		dato.nro_partida_nacimiento := VALOR_ALTO;
end;

procedure leer_fall(var archivo:archivo_fallecimientos; var dato:fallecimiento);
begin
    if (not eof( archivo ))then 
		read (archivo, dato)
    else 
		dato.nro_partida_nacimiento := VALOR_ALTO;
end;

{minimo}

procedure minimo_nacimientos (var reg_det: arreglo_reg_nacimientos; var min:nacimiento; var deta:arreglo_nacimientos);
var 
	i: integer;
	minCod:integer;
	minPos:integer;
begin
	minPos:=1;
    minCod:=32767;
    for i:= 1 to dimF do begin    	
		if(reg_det[i].nro_partida_nacimiento < minCod)then begin
				min := reg_det[i];
				minCod := reg_det[i].nro_partida_nacimiento;
				minPos := i;
		end;
	end;
	leer_naci(deta[minPos], reg_det[minPos]);
end;   



procedure minimo_fallecimientos(var reg_det: arreglo_reg_fallecimientos; var min:fallecimiento; var deta:arreglo_fallecimientos);
var 
	i: integer;
	minCod:integer;
	minPos:integer;
begin
	minPos:=1;
    minCod:=32767;
    for i:= 1 to dimF do begin    	
		if(reg_det[i].nro_partida_nacimiento < minCod)then begin
				min := reg_det[i];
				minCod := reg_det[i].nro_partida_nacimiento;
				minPos := i;
		end;
	end;
	leer_fall(deta[minPos], reg_det[minPos]);
end;   

{body of merge}

var 
	min_fa: fallecimiento;
	min_na: nacimiento;
    reg_det_na: arreglo_reg_nacimientos;
    reg_det_fa: arreglo_reg_fallecimientos;
    regm: informacion;
    i: integer;
    icast : String;

begin
	for i:= 1 to dimF do begin
	    Str(i,icast);
		assign (v_deta_nacim[i], 'detalle-nacimiento-'+icast); 
		assign (v_deta_fall[i], 'detalle-fallecimiento-'+icast);
		reset (v_deta_nacim[i]);
		reset (v_deta_fall[i]);
		leer_naci(v_deta_nacim[i], reg_det_na[i] );
		leer_fall(v_deta_fall[i], reg_det_fa[i] );
	end; 
	
	
	rewrite(a);
	
	minimo_nacimientos (reg_det_na, min_na, v_deta_nacim);
	minimo_fallecimientos (reg_det_fa, min_fa, v_deta_fall);
	
	while (min_na.nro_partida_nacimiento <> VALOR_ALTO) do begin
		regm.fallecio := (min_na.nro_partida_nacimiento = min_fa.nro_partida_nacimiento);
		
		regm.nro_partida_nacimiento := min_na.nro_partida_nacimiento;
		regm.nombre := min_na.nombre;
		regm.apellido := min_na.apellido;
		regm.dir := min_na.dir;
		regm.matricula_medico := min_na.matricula_medico;
		regm.nombre_madre := min_na.nombre_madre;
		regm.apellido_madre := min_na.apellido_madre;
		regm.dni_madre := min_na.dni_madre;
		regm.nombre_padre := min_na.nombre_padre;
		regm.apellido_padre := min_na.apellido_padre;
		regm.dni_padre := min_na.dni_padre;
		if(regm.fallecio)then begin
			regm.matricula_medico_deceso := min_fa.matricula_medico_deceso;
			regm.fecha_deceso := min_fa.fecha_deceso;
			regm.hora_deceso := min_fa.hora_deceso;
			regm.lugar_deceso := min_fa.lugar_deceso;
			minimo_fallecimientos (reg_det_fa, min_fa, v_deta_fall);
		end;
		minimo_nacimientos (reg_det_na, min_na, v_deta_nacim);
		
		write(a, regm);
     end;    
	for i:= 1 to dimF do begin
		close(v_deta_nacim[i]);
		close(v_deta_fall[i]);
	end;
	close(a);
end;

{=============================================================================================================================================================}

procedure listarText(var a:archivo; var txt:Text);
var
	regm :informacion;
begin
	assign(txt, 'archivodetexto.txt');
	reset(a);
	rewrite(txt);
	writeln(txt, 'INFORMACION DE ACTAS DE NACIMIENTO Y FALLECIMIENTOS:');
	while(not eof(a))do begin
		writeln(txt, ' ');
		read(a, regm);
		with regm do begin
			writeln('ACTA DE NACIMIENTO: ');
			writeln(txt,'Nro de partida de nacimiento: ' ,regm.nro_partida_nacimiento);
			writeln(txt,' Nombre: ',regm.nombre,' Apellido: ',regm.apellido);
			writeln(txt,'Direccion:', ' calle: ',regm.dir.calle,' numero: ',regm.dir.nro,' piso: ',regm.dir.piso,' depto: ' ,regm.dir.depto,' ciudad ',regm.dir.ciudad);
			writeln(txt,' matricula del medico nacimiento: ',regm.matricula_medico);
			writeln(txt, ' nombre de la madre: ',regm.nombre_madre,' apellido de la madre: ',regm.apellido_madre,' dni de la madre: ',regm.dni_madre);
			writeln(txt,' nombre del padre: ',regm.nombre_padre,' apellido del padre: ',regm.apellido_padre,' dni del padre: ',regm.dni_padre); 
			if(regm.fallecio)then
				writeln(txt, 'ACTA DE FALLECIMIENTO: ');
				writeln(txt,' matricula del medico que firmo el deceso: ',regm.matricula_medico_deceso,' fecha de deceso: ' ,regm.fecha_deceso,' hora de deceso: ',regm.hora_deceso,' lugar de deceso: ',regm.lugar_deceso);
 
		end;
	end;
	close(a);
	close(txt);
end;

{=============================================================================================================================================================}

var
	detalles_nacimientos: arreglo_nacimientos;
	detalles_fallecimientos: arreglo_fallecimientos;
	maestro : archivo;
	txt : Text;
begin
	assign(maestro, 'maestro');
	
	leer_detalles_nacimientos(detalles_nacimientos);
	leer_detalles_fallecimientos(detalles_fallecimientos);
	merge_archivos(maestro, detalles_nacimientos,detalles_fallecimientos);
	listarText(maestro, txt);
end.
