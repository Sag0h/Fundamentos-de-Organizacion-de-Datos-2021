program ejer13;
const
	valor_alto = 9999;

type

	log=record
		nro_usuario : integer;
		nombreUsuario : string[15];
		nombre : string[15];
		apellido : string[15];
		cantidadMailEnviados : integer;
	end;
	
	detalle=record
		nro_usuario : integer;
		cuentaDestino : string[15];
		cuerpoMensaje : string[15];
	end;
	
	logs=file of log;
	
	archivo_diario=file of detalle;
	
{=====================================================================================================================================================}

procedure leerInfo(var datos:log);
begin
	with datos do begin
		write('Ingrese nro de usuario: ');
		readln(nro_usuario);
		if(nro_usuario <> 0) then begin
			write('Ingrese nombre de usuario: ');
			readln(nombreUsuario);
			write('Ingrese nombre: ');
			readln(nombre);
			write('Ingrese apellido: ');
			readln(apellido);
			write('Ingrese cantidad de mails enviados: ');
			readln(cantidadMailEnviados);
		end;
	end;
end;

{==========================================================================================================================================}	

procedure crear_maestro(var a:logs);
var
	p:log;
begin

	writeln('INGRESAR LA INFORMACION ORDENADA POR NUMERO DE USUARIO! ');
	rewrite(a);
	leerInfo(p);
	while(p.nro_usuario <> 0 )do begin
		write(a, p);
		leerInfo(p);
	end;
	close(a);
end;

{=====================================================================================================================================================}

procedure leer_detalles(var datos:detalle);
begin
	with datos do begin
		write('Ingrese numero de usuario: ');
		readln(nro_usuario);
		if(nro_usuario <> 0)then begin
			write('Ingrese cuenta destino: ');
			readln(cuentaDestino);
			write('Ingrese cuerpo del mensaje: ');
			readln(cuerpoMensaje);
		end;
	end;
end;


procedure generar_detalle(var d:archivo_diario);
var
	datos: detalle;
begin
	writeln('INGRESAR LA INFORMACION ORDENADA POR NUMERO DE USUARIO! ');
	rewrite(d);
	leer_detalles(datos);
	while(datos.nro_usuario <> 0) do begin
		write(d, datos);
		leer_detalles(datos);
	end;
	close(d);
end;

{=====================================================================================================================================================}

procedure leer(var a: archivo_diario; var datos:detalle);
begin
	if(not eof(a))then
		read(a, datos)
	else
		datos.nro_usuario := valor_alto;
end;

procedure actualizar_maestro(var maestro:logs; var detalle:archivo_diario);
var
	info:log;
	det:detalle;
	nro_usuario_act : integer;
begin
	reset(maestro);
    reset(detalle);
	leer(detalle, det);
    while (det.nro_usuario <> valor_alto) do begin	
		read(maestro, info);
		while (info.nro_usuario <> det.nro_usuario) do
            read(maestro, info);
            
		nro_usuario_act := det.nro_usuario;
		while(det.nro_usuario = nro_usuario_act)do begin
			info.cantidadMailEnviados := info.cantidadMailEnviados + 1;
			leer(detalle, det);
		end;

        seek(maestro, filepos(maestro) - 1);

        write(maestro, info);
    end;

    close(maestro);
    close(detalle);

end;

{=====================================================================================================================================================}

procedure generar_txt_de_maestro(var a:logs; var txt:Text);
var
	regm: log;
begin
	reset(a);
	rewrite(txt);
	while(not eof(a))do begin
		read(a, regm);
		with regm do writeln(txt,nro_usuario,' ',cantidadMailEnviados);
	end;
	close(a);
	close(txt);
end;

{=====================================================================================================================================================}

{Programa Principal}

var
	a:logs;
	d:archivo_diario;
	txt:Text;
begin
	assign(txt, 'cantidad_por_dias.txt');
	assign(a, '/home/sagoh/Desktop/Facultad/FOD/Fundamentos-de-Organizacion-de-Datos-2021/3-Practicas/Practica-2/Ejercicio13/var/log/logmail.dat');
	assign(d, 'diario');
	crear_maestro(a);
	generar_detalle(d);
	actualizar_maestro(a,d);
	generar_txt_de_maestro(a,txt);
end.
