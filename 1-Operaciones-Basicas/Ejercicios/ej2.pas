{Realice un algoritmo que permita guardar en un archivo todos
los productos que actualmente se encuentran en venta en un
determinado negocio. La información que es importante conside-
rar es: nombre del producto, cantidad actual, precio unitario de
venta, tipo de producto (que puede ser comestible, de limpieza o
vestimenta).}

program ej2;

type
	
	producto = record
		nombre : String[15];
		cantidadAct : integer;
		precioUni : real;
		tipo : String[15];
	end;
	
	archivos = file of producto;

procedure leerP(var P:producto);
var
	ok:boolean;
begin
	ok:=true;
	write('INGRESE TIPO DE PRODUCTO (comestible - limpieza - vestimenta):');
	readln(P.tipo);
	ok:=true;
	while(ok)do begin
		if (P.tipo = 'fin') then
			ok:= false
		else begin
			if((P.tipo <> 'comestible') and (P.tipo <> 'limpieza') and (P.tipo <> 'vestimenta'))then begin
				write('TIPO DE PRODUCTO INCORRECTO, INTRODUZCA UNO CORRECTO (comestible - limpieza - vestimenta) (EN MINUSCULA)');
				write(' SINO INGRESE "fin" PARA TERMINAR LA LECTURA:');
				readln(P.tipo);
			end
			else
				ok:=false;
		end;
	end;
	if(P.tipo <> 'fin')then begin
		write('INGRESE CANTIDAD ACTUAL: ');
		readln(P.cantidadAct);
		write('INGRESE PRECIO UNITARIO: ');
	    readln(P.precioUni);
		write('INGRESE NOMBRE DE PRODUCTO: ');
		readln(P.nombre);
	end;
end;

var 
	p:producto;
	arch_productos:archivos;
begin
	Assign(arch_productos, '/home/sagoh/Escritorio/FOD/book-practice/ej2.data');
	rewrite(arch_productos);
	leerP(p);
	while(p.tipo <> 'fin')do begin
		write(arch_productos,p);
		leerP(p);
	end;
end.
