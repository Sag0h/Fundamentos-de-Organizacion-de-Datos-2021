program ejer4;
 
const
	dimF = 5;
	VALOR_ALTO = 9999;
type
	
	fechas = record
		dia : 1..31;
		mes : 1..12;
		anio : 2000..2050;
	end;
	
	log = record
		cod_usuario : integer;
		fecha : fechas;
		tiempo_sesion : integer;
	end;
	
	log_general = record
		fecha : fechas;
		cod_usuario : integer;
		tiempo_total_de_sesiones_abiertas : integer;
	end;
	
	archivo_detalle = file of log;
	archivo_maestro = file of log_general;
	
	arreglo_detalle = array[1..dimF] of archivo_detalle;
	reg_detalle = array[1..dimF] of log;
	
{==================================================================================================================}

procedure leerDetalles(var v:arreglo_detalle);
var
	i: integer;
	datos: log;
	str_i: string;
begin
	writeln('- - - - - - - - LECTURA DE ARCHIVOS DETALLE - - - - - - - -');
	for i:= 1 to dimF do begin
		
		{abro el archivo de la posicion actual}
		
		Str(i, str_i);
		assign(v[i], 'detalle'+str_i);
		rewrite(v[i]);
		
		{lleno el archivo actual}
		
		writeln('Maquina ', i, ':');
		writeln('INGRESAR LA INFORMACION ORDENADA POR CODIGO DE USUARIO Y FECHA!!');
		write('Ingresar codigo de usuario: ');
		readln(datos.cod_usuario);
		while(datos.cod_usuario <> 0)do begin
			write('Ingrese dia: ');
			readln(datos.fecha.dia);
			write('Ingrese mes: ');
			readln(datos.fecha.mes);
			write('Ingrese anio: ');
			readln(datos.fecha.anio);
			write('Ingrese cantidad de minutos de sesion: ');
			readln(datos.tiempo_sesion);
			write(v[i], datos);
			write('Ingrese codigo de usuario: ');
			readln(datos.cod_usuario);
		end;
		close(v[i]); {cierro el actual}
	end;

end;

{==================================================================================================================}

procedure MergeArchivos(var a:archivo_maestro; var detalles: arreglo_detalle);

procedure leer(var archivo:archivo_detalle; var dato:log);
begin
    if (not eof( archivo ))then 
		read (archivo, dato)
    else 
		dato.cod_usuario := VALOR_ALTO;
end;



procedure minimo (var reg_det: reg_detalle; var min:log; var deta:arreglo_detalle);
var 
	i: integer;
	minCod:integer;
	minPos:integer;
	
	minDia:integer;
	minMes:integer;
	minAnio:integer;
begin
	minDia:=31;
	minMes:=12;
	minAnio:=2050;
	
	minPos:=1;
    minCod:=32767;
    for i:= 1 to dimF do begin    	
		if(reg_det[i].cod_usuario <= minCod)and(reg_det[i].fecha.dia <= minDia)and(reg_det[i].fecha.mes <= minMes)and(reg_det[i].fecha.anio <= minAnio)then begin
				min := reg_det[i];
				minCod := reg_det[i].cod_usuario;
				minPos := i;
				
				minDia := reg_det[i].fecha.dia;
				minMes := reg_det[i].fecha.mes;
				minAnio := reg_det[i].fecha.anio;
		end;
	end;
	leer(deta[minPos], reg_det[minPos]);
	
end;   

{body of Merge}

var 
	min: log;
    reg_det: reg_detalle;
    regm: log_general;
    i: integer;
    icast : String;

begin
	for i:= 1 to dimF do begin
	    Str(i,icast);
		assign (detalles[i], 'detalle'+icast); 
		reset( detalles[i] );
		leer( detalles[i], reg_det[i] );
	end; 
	
	
	rewrite(a);
	
	minimo (reg_det, min, detalles);
	while (min.cod_usuario <> VALOR_ALTO) do begin
		regm.cod_usuario := min.cod_usuario;
		regm.fecha := min.fecha;
		regm.tiempo_total_de_sesiones_abiertas := 0;
		while (regm.cod_usuario = min.cod_usuario)and(regm.fecha.dia = min.fecha.dia)and(regm.fecha.mes = min.fecha.mes)and(regm.fecha.anio = min.fecha.anio)do begin
			regm.tiempo_total_de_sesiones_abiertas := regm.tiempo_total_de_sesiones_abiertas + min.tiempo_sesion;
			minimo (reg_det, min, detalles);
		end;
		write(a, regm);
     end;    
	for i:= 1 to dimF do begin
		close(detalles[i]);
	end;
	close(a);
end;

{==================================================================================================================}

{programa principal}

var
	maestro : archivo_maestro;
	detalles : arreglo_detalle;
	regm : log_general;
begin
	leerDetalles(detalles);
	assign(maestro, '/home/sagoh/Desktop/Facultad/FOD/Fundamentos-de-Organizacion-de-Datos-2021/3-Practicas/Practica-2/Ejercicio4/var/log/maestro');
	MergeArchivos(maestro, detalles);
	reset(maestro);
	while(not eof(maestro))do begin
		read(maestro, regm);
		writeln('Fecha: ', regm.fecha.dia, '-', regm.fecha.mes, '-', regm.fecha.anio, ' - '  , 'Codigo de usuario: ', regm.cod_usuario, ' tiempo total: ', regm.tiempo_total_de_sesiones_abiertas);
	end;
	close(maestro);
end.
