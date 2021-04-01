program ejercicio1;
const
	valor_alto = 9999;

type
	
	venta=record
		cod:integer;
		nombre:string;
		monto:real;
	end;

	regventas = file of venta;

procedure leer (var archivo: regventas; var dato:venta);
begin
	if (not eof(archivo)) then
		read (archivo,dato)
	else
		dato.cod:= valor_alto;
end;
	
procedure compactar(var archivo:regventas; var archivo2:regventas);

var
	reg:venta;
	reg_act:venta;
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
	archivo:regventas;
	archivo_nuevo:regventas;

begin	
	assign(archivo, 'archivo');
	assign(archivo_nuevo, 'ventas2');
	reset(archivo);
	if(not(EOF(archivo)))then begin
		rewrite(archivo_nuevo);
		compactar(archivo, archivo_nuevo);	
		close(archivo_nuevo);
	end;
	close(archivo);
end.
