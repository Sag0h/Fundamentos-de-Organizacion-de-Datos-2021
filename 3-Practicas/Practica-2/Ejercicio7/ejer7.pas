program ejer7;
const
	VALOR_ALTO = 9999;
type
	
	producto = record
		cod:integer;
		nombre:string[15];
		stock:integer;
		stockMin:integer;
		precio:real;
	end;
	
	actualizacion = record
		cod:integer;
		cantV:integer;
	end;
	
	archivo_maestro = file of producto;
	
	archivo_detalle = file of actualizacion;

{==============================================================================================================================================================================}

procedure crearMaestro(var a:archivo_maestro);
var
	txt:Text;
	p:producto;
begin
	assign(txt, 'productos.txt');
	reset(txt);
	rewrite(a);
	while(not eof(txt))do begin
		readln(txt, p.nombre);
		readln(txt, p.cod, p.precio, p.stock, p.stockMin);
		write(a, p);
	end;
	close(a);
	close(txt);
end;

{==============================================================================================================================================================================}

procedure listarReporte(var a:archivo_maestro);
var
	txt:Text;
	p:producto;
begin
	assign(txt, 'reporte.txt');
	reset(a);
	rewrite(txt);
	while(not eof(a))do begin
		read(a, p);
		writeln(txt,'Codigo de producto: ', p.cod ,' Nombre de producto: ', p.nombre, ' Precio: ', p.precio, ' Stock actual: ', p.stock, ' Stock minimo: ', p.stock);
	end;
	close(txt);
	close(a);
end;

{==============================================================================================================================================================================}

procedure crearDetalle(var a:archivo_detalle);
var
	txt:Text;
	datos:actualizacion;
begin
	assign(txt, 'ventas.txt');
	reset(txt);
	rewrite(a);
	while(not eof(txt))do begin
		readln(txt, datos.cod, datos.cantV);
		write(a, datos);
	end;
	close(txt);
	close(a);
end;

{==============================================================================================================================================================================}

procedure listarDetalleEnPantalla(var a:archivo_detalle);
var
	d:actualizacion;
begin
	reset(a);
	while(not eof(a))do begin
		read(a, d);
		writeln('Codigo de producto: ', d.cod, ' - Cantidad vendida: ', d.cantV,'.');
	end;
	close(a);
end;

{==============================================================================================================================================================================}

procedure actualizarMaestro(var a:archivo_maestro; var d:archivo_detalle);
var
	act:actualizacion;
	p:producto;
begin
	reset(a);
    reset(d);

    while (not eof(d)) do begin
        read(a, p);
        read(d, act);

        while (p.cod <> act.cod) do
            read(a, p);

        p.stock := p.stock - act.cantV;

        seek(a, filepos(a) - 1);

        write(a, p);
    end;

    close(a);
    close(d);
end;

{==============================================================================================================================================================================}

procedure exportarTxt(var a:archivo_maestro; var txt:Text);
var
	regm:producto;
begin
	rewrite(txt);
	reset(a);
	while(not eof(a))do begin
		read(a,regm);
		if(regm.stock < regm.stockMin)then
			with regm do
				writeln(txt,'Codigo de producto: ', cod ,' nombre de producto: ', nombre,' stock minimo: ', stockMin ,' - stock disponible: ', stock,' - $', precio:2:2,'.');  	
	end;
	close(a);
	close(txt);
end;	

{==============================================================================================================================================================================}

{programa principal}

var
	a:archivo_maestro;
	d:archivo_detalle;
	txt:Text;
begin
	assign(a, 'maestro');
	assign(d, 'detalle');
	assign(txt, 'stock_minimo.txt');
	
	crearMaestro(a);
	listarReporte(a);
	crearDetalle(d);
	listarDetalleEnPantalla(d);
	actualizarMaestro(a,d);
	exportarTxt(a, txt);
end.
