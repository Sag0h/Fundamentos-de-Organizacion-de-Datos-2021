
program ej3;

type
	
	producto = record
		nombre : String[15];
		cantidadAct : integer;
		precioUni : real;
		tipo : String[15];
	end;
	
	archivos = file of producto;


{Teniendo como base al ejercicio anterior, plantee un algoritmo
que permita presentar en pantalla los productos del archivo que
correspondan al rubro de limpieza o cuya cantidad actual supere
las 100 unidades.}

var
	p:producto;
	a:archivos;
begin
	Assign(a, '/home/sagoh/Escritorio/FOD/book-practice/ej2.data');
	reset(a);
	while(not eof(a))do begin
		read(a, p);
		if(p.tipo = 'limpieza') and (p.cantidadAct > 100)then 
			writeln('PRODUCTO ', p.nombre, ' - PRECIO UNITARIO ', p.precioUni:2:2);		
	end;
	close(a);
end.


