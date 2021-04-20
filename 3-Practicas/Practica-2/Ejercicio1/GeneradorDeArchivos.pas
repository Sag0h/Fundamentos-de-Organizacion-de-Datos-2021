program GenArchivos;
type
	venta=record {cambiar por el tipo que sea}
		cod:integer;
		nombre:string;
		monto:real;
	end;
	
	archivo = file of venta; {cambiar por el tipo que sea}
	
	
procedure RandomData(var a:archivo);
var
	datos:venta;
	cod:integer;
	strcod:string;

begin
	rewrite(a);
	writeln('>>>>>>>>>>>>>> INGRESAR LA INFORMACION ORDENADA POR CODIGO <<<<<<<<<<<<<<<<');
	write('Ingrese codigo: ');
	readln(cod); 
	while(cod <> 0)do begin
		datos.cod := cod;
		datos.monto := Random(501);
		Str(cod,strcod);
		datos.nombre := 'nombreGenerico'+strcod;
		
		write(a, datos);
		write('Ingrese codigo: ');
		readln(cod); 
	end;
	close(a);
end;


var
	a:archivo;
begin
	assign(a, 'archivo');
	RandomData(a);
	readln();
end.
