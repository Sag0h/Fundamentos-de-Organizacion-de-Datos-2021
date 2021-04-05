program ejer8;

const
	valor_alto = 9999;
type
	
	cliente = record
		cod:integer;
		nombre:string[15];
		apellido:string[15];
	end;
	
	venta = record
		c : cliente;
		anio : 2000..2050;
		mes : 1..12;
		dia : 1..31;
		monto : real;
	end;
	
	archivo_ventas = file of venta;
	
{==================================================================================================================================}

procedure leerVentas(var datos:venta);
begin
	with datos do begin
		write('Ingrese codigo de cliente: ');
		readln(c.cod);
		if(c.cod <> 0) then begin
			write('Ingrese anio de la venta: ');
			readln(anio);
			write('Ingrese mes de la venta: ');
			readln(mes);
			write('Ingrese dia de la venta: ');
			readln(dia);
			write('Ingrese monto de la venta: ');
			readln(monto);
			write('Ingrese nombre del cliente: ');
			readln(c.nombre);
			write('Ingrese apellido del cliente: ');
			readln(c.apellido);
		end;
	end;
end;

{==========================================================================================================================================}	

procedure crear_archivo(var a:archivo_ventas);
var
	p:venta;
begin

	writeln('INGRESAR LA INFORMACION ORDENADA POR CODIGO DE CLIENTE, ANIO Y MES!! ');
	rewrite(a);
	leerVentas(p);
	while(p.c.cod <> 0)do begin
		write(a, p);
		leerVentas(p);
	end;
	close(a);
end;

{==================================================================================================================================}

procedure leer(var a:archivo_ventas; var dato:venta);
begin
	if(not eof(a))then
		read(a, dato)
	else
		dato.c.cod := valor_alto;
end;

{==================================================================================================================================}

procedure  informar_reporte(var a:archivo_ventas; var monto_total:real);
var
	regm:venta;
	total_anio:real;
	cod_act:integer;
	anio_act:integer;
	mes_act:integer;
	total_mes:real;
begin
	reset(a);
	leer(a,regm);
	while(regm.c.cod <> valor_alto)do begin
		writeln('Codigo del Cliente:', regm.c.cod);
		writeln('Nombre y Apellido del Cliente:',regm.c.nombre,' ', regm.c.apellido);
		cod_act := regm.c.cod;
		anio_act :=regm.anio;
		total_anio:= 0;
		
		while(regm.c.cod = cod_act)and(regm.anio = anio_act)do begin
			
			mes_act:=regm.mes;
			total_mes:=0;
			
			while(regm.c.cod = cod_act)and(regm.anio = anio_act)and(regm.mes = mes_act)do begin
				total_mes := total_mes + regm.monto;
				leer(a, regm);
			end;
			total_anio:=total_anio + total_mes;
			writeln('Total mensual - MES ', mes_act,'- ANIO ', anio_act,': $', total_mes:2:2); 	
			
		end;
		
		writeln('Total comprado en el año "', anio_act ,'", por el cliente de codigo "', cod_act, '" : $', total_anio:2:2,'.');
		monto_total := monto_total + total_anio;
		writeln(' ');	
	end;
	close(a);
end;

{==================================================================================================================================}


{Programa Principal}

var
	a:archivo_ventas;
	monto_total:real;
begin
	monto_total:=0;
	assign(a,'informacion_de_ventas');
	crear_archivo(a);
	informar_reporte(a, monto_total);
	writeln('Monto total de ventas obtenido por la empresa $',monto_total:2:2);
end.
