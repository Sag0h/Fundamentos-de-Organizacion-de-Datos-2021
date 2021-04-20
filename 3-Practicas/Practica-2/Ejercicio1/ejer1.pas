program ejercicio1;
const
	valor_alto = 9999;

type
	
	comision=record
		cod:integer;
		nombre:string;
		monto:real;
	end;

	regcomision = file of comision;

procedure leer (var archivo: regcomision; var dato:comision);
begin
	if (not eof(archivo)) then
		read (archivo,dato)
	else
		dato.cod:= valor_alto;
end;
	
procedure compactar(var archivo:regcomision; var archivo2:regcomision);

var
	reg:comision;
	reg_act:comision;
begin
	leer(archivo, reg);
	while(reg.cod <> valor_alto)do begin
		reg_act := reg;
		reg_act.monto := 0;
		while(reg_act.cod = reg.cod)do begin
 			reg_act.monto := reg_act.monto + reg.monto;
			leer(archivo,reg);
		end;
		write(archivo2, reg_act);
	end;	
end;

{programa principal}

var
	archivo:regcomision;
	archivo_nuevo:regcomision;

begin	
	assign(archivo, 'archivo');
	assign(archivo_nuevo, 'comision');
	reset(archivo);
	if(not(EOF(archivo)))then begin
		rewrite(archivo_nuevo);
		compactar(archivo, archivo_nuevo);	
		close(archivo_nuevo);
	end;
	close(archivo);
end.
