program ejer9;
const
	valor_alto = 9999;
type
	mesa = record
		cod_prov:integer;
		cod_loc:integer;
		num_mesa:integer;
		cant_votos:integer;
	end;
	
	archivo_votos = file of mesa;
	


{============================================================================================================================================================================}

procedure leer_mesa(var datos:mesa);
begin
	with datos do begin
		write('Ingrese codigo de provincia: ');
		readln(cod_prov);
		if(cod_prov <> 0) then begin
			write('Ingrese codigo de localidad: ');
			readln(cod_loc);
			write('Ingrese numero de mesa: ');
			readln(num_mesa);
			write('Ingrese cantidad de votos de la mesa: ');
			readln(cant_votos);
		end;
	end;
end;

{==========================================================================================================================================}	

procedure crear_archivo(var a:archivo_votos);
var
	p:mesa;
begin
	writeln('INGRESAR LA INFORMACION ORDENADA POR CODIGO DE PROVINCIA Y CODIGO DE LOCALIDAD!! ');
	rewrite(a);
	leer_mesa(p);
	while(p.cod_prov <> 0)do begin
		write(a, p);
		leer_mesa(p);
	end;
	close(a);
end;

{============================================================================================================================================================================}

procedure leer(var a:archivo_votos; var dato:mesa);
begin
	if(not eof(a))then
		read(a, dato)
	else
		dato.cod_prov := valor_alto;
end;

{==================================================================================================================================}

procedure listar_info(var a:archivo_votos);
var
	regm:mesa;
	cod_prov_act:integer;
	total_prov:integer;
	
	cod_loc_act:integer;
	total_loc_act:integer;
	
	total_general_votos:integer;
	
begin
	total_general_votos:=0;
	reset(a);
	leer(a,regm);
	while(regm.cod_prov <> valor_alto)do begin
		writeln('..............................................');
		writeln('Codigo de Provincia: ', regm.cod_prov);
		writeln('..............................................');
		writeln('Codigo de Localidad:         Total de Votos:');
		writeln('');
		cod_prov_act := regm.cod_prov;
		total_prov:= 0;
		
		while(regm.cod_prov = cod_prov_act)do begin
			
			cod_loc_act := regm.cod_loc;
			total_loc_act := 0;
			
			while(regm.cod_prov = cod_prov_act)and(regm.cod_loc = cod_loc_act)do begin
				total_loc_act := total_loc_act + regm.cant_votos;
				leer(a, regm);
			end;
			total_prov:=total_prov + total_loc_act;
			writeln(cod_loc_act,'                            ', total_loc_act);
			
		end;
		writeln('');
		writeln('Total de votos Provincia: ', total_prov);
		total_general_votos := total_general_votos + total_prov;
	end;
	writeln('..............................................');
	writeln('Total General de Votos: ', total_general_votos);
	close(a);
end;

{============================================================================================================================================================================}

{Programa Principal}

var
	a:archivo_votos;
begin
	assign(a,'archivo_votos');
	crear_archivo(a);
	listar_info(a);
end.
