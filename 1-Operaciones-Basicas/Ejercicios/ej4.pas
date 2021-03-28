{Realice un algoritmo que permita modificar los precios unitarios
de los productos del archivo generado en el Ejercicio 2, incre-
mentando en 10% los correspondientes al rubro comestibles, en
5% a los de limpieza y en 20% a los de vestimenta.}

program ej4;

type
	
	producto = record
		nombre : String[15];
		cantidadAct : integer;
		precioUni : real;
		tipo : String[15];
	end;
	
	archivos = file of producto;

var
	a:archivos;
	p:producto;
	incremento:real;
begin
	Assign(a, '/home/sagoh/Escritorio/FOD/book-practice/ej2.data');
	reset(a);
	while(not eof(a))do begin
		read(a,p);
		if(p.tipo = 'comestible')then begin
			incremento := ((p.precioUni * 10) / 100);
			p.precioUni := p.precioUni + incremento; 
		end
		else 
			if(p.tipo = 'limpieza')then begin
				incremento := ((p.precioUni * 5) / 100);
				p.precioUni := p.precioUni + incremento; 
			end
			else begin
				incremento := ((p.precioUni * 20) / 100);
				p.precioUni := p.precioUni + incremento; 
			end;
		
		seek(a, filepos(a)-1);
		write(a, p); 
	end;
	close(a);

end.
