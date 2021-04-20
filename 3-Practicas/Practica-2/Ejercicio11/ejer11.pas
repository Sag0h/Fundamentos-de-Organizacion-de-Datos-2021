program ejer11;
const
	cant_detalles = 2;
	valor_alto = 'zzzzzzz';
type
	
	info_alfabetizacion = record
		nombre_provincia : string[15];
		cant_alfabetizadas : integer;
		cant_encuestados : integer;
	end;
	
	archivo_maestro = file of info_alfabetizacion;
	
	actualizacion = record
		nombre_provincia : string[15];
		cod_localidad : integer;
		cant_alfabetizadas : integer;
		cant_encuestados : integer;
	end;
	
	archivo_detalle = file of actualizacion;
	
	archivos_detalle = array [1..cant_detalles] of archivo_detalle;
	registros_detalle = array[1..cant_detalles] of actualizacion;

{============================================================================================================================================================================}


procedure leerInfo(var datos:info_alfabetizacion);
begin
	with datos do begin
		write('Ingrese Provincia: ');
		readln(nombre_provincia);
		if(nombre_provincia <> 'zzz') then begin
			write('Ingrese cantidad de personas alfabetizadas: ');
			readln(datos.cant_alfabetizadas);
			write('Ingrese cantidad de personas encuestadas: ');
			readln(datos.cant_encuestados);
		end;
	end;
end;

{==========================================================================================================================================}	

procedure crearMaestro(var a:archivo_maestro);
var
	p:info_alfabetizacion;
begin

	writeln('INGRESAR LA INFORMACION ORDENADA POR NOMBRE DE PROVINCIA! ');
	rewrite(a);
	leerInfo(p);
	while(p.nombre_provincia <> 'zzz')do begin
		write(a, p);
		leerInfo(p);
	end;
	close(a);
end;

{==========================================================================================================================================}	

procedure leerDetalles(var v:archivos_detalle);
var
	i: integer;
	datos: actualizacion;
	str_i: string;
begin
	writeln('- - - - - - - - LECTURA DE ARCHIVOS DETALLE - - - - - - - -');
	for i:= 1 to cant_detalles do begin
		
		{abro el archivo de la posicion actual}
		
		Str(i, str_i);
		assign(v[i], 'detalle'+str_i);
		rewrite(v[i]);
		
		{lleno el archivo actual}
		
		writeln('Agencia de censo ', i, ':');
		writeln('INGRESAR LA INFORMACION ORDENADA POR NOMBRE DE PROVINCIA!!');
		write('Ingrese Provincia: ');
		readln(datos.nombre_provincia);
		while(datos.nombre_provincia <> 'zzz')do begin
			write('Ingrese codigo de localidad: ');
			readln(datos.cod_localidad);
			write('Ingrese cantidad de personas alfabetizadas: ');
			readln(datos.cant_alfabetizadas);
			write('Ingrese cantidad de personas encuestadas: ');
			readln(datos.cant_encuestados);
			write(v[i], datos);
			write('Ingrese Provincia: ');
			readln(datos.nombre_provincia);
		end;
		close(v[i]); {cierro el actual}
	end;

end;

{==========================================================================================================================================}

procedure leer(var a:archivo_detalle; var dato:actualizacion);
begin
    if (not eof( a ))then 
		read (a, dato)
    else 
		dato.nombre_provincia := valor_alto;
end;

{==========================================================================================================================================}

procedure getMin (var reg_det: registros_detalle; var min:actualizacion; var deta:archivos_detalle);
var 
	i: integer;
	minProv:string;
	minPos:integer;
begin
      { busco el mínimo elemento del 
        vector reg_det en el campo cod,
        supongamos que es el índice i }
    minPos := 1;
    minProv:='zzzzzzzz';
    for i:= 1 to cant_detalles do begin    	
		if(reg_det[i].nombre_provincia < minProv)then begin
			min := reg_det[i];
			minProv := reg_det[i].nombre_provincia;
			minPos := i;
		end;
	end;
	leer(deta[minPos], reg_det[minPos]);
	
end;     

{==========================================================================================================================================}

procedure actualizarInfo(var a:archivo_maestro; var detalles:archivos_detalle);
var
	i:integer;
	min:actualizacion;
	regm: info_alfabetizacion;
	icast:string;
	reg_det: registros_detalle;
	total_alfabetizadas: integer;
	total_encuestados: integer;
	prov_act: string;
begin
	for i:= 1 to cant_detalles do begin
		Str(i,icast);
		assign (detalles[i], 'detalle'+icast); 
		reset( detalles[i] );
		leer( detalles[i], reg_det[i]);
	end;
	
	reset(a);
	getMin(reg_det, min, detalles); {busco el detalle minimo}
	while (min.nombre_provincia <> valor_alto) do begin
		total_alfabetizadas := 0;
		total_encuestados := 0;
		prov_act := min.nombre_provincia;
		while(prov_act = min.nombre_provincia ) do begin
			total_alfabetizadas := total_alfabetizadas + min.cant_alfabetizadas;
			total_encuestados := total_encuestados + min.cant_encuestados;
			getMin (reg_det, min, detalles);
		end;
		
		read(a, regm);
		while(regm.nombre_provincia <> prov_act)do 
			read(a, regm);
		regm.cant_encuestados := regm.cant_encuestados + total_encuestados;
		regm.cant_alfabetizadas := regm.cant_alfabetizadas + total_alfabetizadas;
		seek(a, filepos(a)-1);
		write(a, regm);
	end;    
	for i:= 1 to cant_detalles do begin
		close(detalles[i]);
	end;
	close(a);
end;

{============================================================================================================================================================================}

{Programa Principal}

var
	a:archivo_maestro;
	regm:info_alfabetizacion;
	arreglo_detalles: archivos_detalle;
begin
	assign(a, 'archivo');
	crearMaestro(a);
	leerDetalles(arreglo_detalles);
	actualizarInfo(a,arreglo_detalles);
	reset(a);
	while(not eof(a))do begin
		read(a, regm);
		writeln('Provincia: ', regm.nombre_provincia, ' Cantidad alfabetizadas: ', regm.cant_alfabetizadas, ' Cantidad de personas encuestadas: ', regm.cant_encuestados);
	end;
end.
