{Realizar un programa que presente un menú con opciones para:
a. Crear un archivo de registros no ordenados de empleados y completarlo con
datos ingresados desde teclado. De cada empleado se registra: número de
empleado, apellido, nombre, edad y DNI. Algunos empleados se ingresan con
DNI 00. La carga finaliza cuando se ingresa el String ‘fin’ como apellido.
b. Abrir el archivo anteriormente generado y
i. Listar en pantalla los datos de empleados que tengan un nombre o apellido
determinado.
ii. Listar en pantalla los empleados de a uno por línea.
iii. Listar en pantalla empleados mayores de 70 años, próximos a jubilarse.
NOTA: El nombre del archivo a crear o utilizar debe ser proporcionado por el usuario una
única vez.}

program ej3;

type
	empleado = record
		numE:string;
		ape:string;
		nombre:string;
		edad:integer;
		dni:string;
	end;

	archivo = file of empleado;

procedure leerEmpleado(var e:empleado);
begin
	write('Ingrese apellido: ');
	readln(e.ape);
	if(e.ape <> 'fin')then begin
		write('Ingrese nombre: ');
		readln(e.nombre);
		write('Ingrese edad: ');
		readln(e.edad);
		write('Ingrese dni: ');
		readln(e.dni);
		write('Ingrese numero de empleado: ');
		readln(e.numE);
	end;
end;

procedure crearArchivo(var a:archivo);	
var
	nombre:string;
	emp:empleado;
begin
	write('Ingrese ruta y nombre del archivo a crear: ');
	readln(nombre);
	writeln('======================================');
	Assign(a,nombre);
	rewrite(a);
	writeln('Ingreso de empleados al archivo:');
	writeln();
	leerEmpleado(emp);
	while(emp.ape <> 'fin')do begin
		writeln('======================================');
		write(a,emp);
		leerEmpleado(emp);
	end;
	close(a);
end;

procedure ImprimirEmpleado(emp:empleado);
begin
	writeln('Nombre: ', emp.nombre, ' Apellido: ', emp.ape,' Edad: ', emp.edad,' DNI: ', emp.dni,' Numero de Empleado: ', emp.numE);
end;

procedure listarNyA(var a:archivo);
var
	emp:empleado;
	nombre:string;
	ape:string;
	ok:boolean;
begin
	ok:=false;
	reset(a);
	write('Ingrese apellido: ');
	readln(ape);
	write('Ingrese nombre: ');
	readln(nombre);
	while(not eof(a))do begin
		read(a,emp);
		if(emp.nombre = nombre)and(emp.ape = ape)then begin
			ok:=true;
			ImprimirEmpleado(emp);
		end;
	end;
	if(not ok)then
		writeln('No existe un empleado con ese nombre y apellido.');
	close(a);
end;


procedure listarEmpleados(var a:archivo);
var
	emp:empleado;
begin
	reset(a);
	while(not eof(a))do begin
		read(a,emp);
		ImprimirEmpleado(emp);
	end;
	close(a);
end;

procedure listarProximosAJubilacion(var a:archivo);
var
	emp:empleado;
begin
	writeln('Empleados mayores a 70 años: ');
	reset(a);
	while(not eof(a))do begin
		read(a,emp);
		if(emp.edad >= 70)then
			ImprimirEmpleado(emp);
	end;
	close(a);
end;

Procedure addEmpleadosAlFinal(var a:archivo);
var
	emp:empleado;
	cant:integer;
	i:integer;
begin
	writeln('======================================');
	write('Ingrese la cantidad de empleados a ingresar: ');
	readln(cant);
	if(cant > 0)then begin
		reset(a);
		seek(a,filesize(a)-1);
		for i:= 1 to cant do begin
			leerEmpleado(emp);
			write(a,emp);
		end;
		close(a);
	end
	else
		writeln('ERROR - La cantidad ingresada no es valida o es 0.');
	
end;

procedure modificarEdadDeEmpleados(var a:archivo);
var
	i:integer;
	numE:string;
	emp:empleado;
	cant:integer;
	edad:integer;
	ok:boolean;
begin
	ok:=false;
	write('Ingrese la cantidad de empleados a la que quiere modificar la edad: ');
	readln(cant);
	if(cant > 0)then begin
		reset(a);
		for i := 1 to cant do begin
			write('Ingrese numero de empleado del empleado al que quiere modificar la edad: ');
			readln(numE);
			while(not eof(a))and(not ok)do begin
				read(a,emp);
				if(emp.numE = numE)then begin
					write('Ingrese nuevo valor para edad: ');
					readln(edad);
					emp.edad := edad;
					seek(a, filepos(a)-1);
					write(a, emp);
					ok:=true;
				end;
			end;
			if(ok)then
				writeln('Se modifico la edad con exito!')
			else
				writeln('No se encontro el empleado con el numero de empleado ingresado!');
			seek(a, 0);
		end;
		close(a);
	end
	else
		writeln('ERROR - La cantidad ingresada no es valida o es 0.');
	
end;

procedure exportarATXT(var a:archivo);
var
	donde:string;
	txt:Text;
	edad:string;
	emp:empleado;
begin
	write('Ingrese ruta donde quiere guardar el nuevo archivo "todos_empleados.txt": ');
	readln(donde);
	writeln('======================================');
	Assign(txt, donde+'todos_empleados.txt');
	rewrite(txt);
	reset(a);
	while(not eof(a))do begin
		read(a,emp);
		write(txt, ' Apellido: '+emp.ape);
		write(txt, ' Nombre:'+emp.nombre);
		write(txt, ' DNI: '+emp.dni);
		write(txt, ' Numero de Empleado: '+emp.numE);
		Str(emp.edad, edad);
		write(txt, ' Edad: '+edad);
	end;
	close(a);
	close(txt);
	writeln('Se copio todos los datos del archivo al archivo .txt con exito!');
end;

procedure exportarFaltaDni(var a:archivo);
var
	donde:string;
	txt:Text;
	edad:string;
	emp:empleado;
begin
	write('Ingrese ruta donde quiere guardar el nuevo archivo "faltaDNIEmpleado.txt": ');
	readln(donde);
	writeln('======================================');
	Assign(txt, donde+'faltaDNIEmpleado.txt');
	rewrite(txt);
	reset(a);
	while(not eof(a))do begin
		read(a,emp);
		if(emp.dni = '00')then begin
			write(txt, ' Apellido: '+emp.ape);
			write(txt, ' Nombre:'+emp.nombre);
			write(txt, ' Numero de Empleado: '+emp.numE);
			Str(emp.edad, edad);
			write(txt, ' Edad: '+edad);
		end;
	end;
	close(a);
	close(txt);
	writeln('Se copio todos los datos de empleados con dni "00" del archivo al archivo .txt con exito!');
end;

procedure DesplegarMenu(var a:archivo);
var
	opcion:integer;
begin	
	writeln('================ MENU ================');
	
	writeln('0. Salir');
	writeln('1. Listar en pantalla los datos de empleados que tengan un nombre o apellido determinado.');
	writeln('2. Listar en pantalla los empleados de a uno por línea.');
	writeln('3. Listar en pantalla empleados mayores de 70 años, próximos a jubilarse.');
	writeln('4. Añadir una o más empleados al final del archivo.');
	writeln('5. Modificar edad a una o más empleados.');
	writeln('6. Exportar el contenido del archivo a un archivo de texto llamado “todos_empleados.txt”.');
	writeln('7. Exportar a un archivo de texto llamado: “faltaDNIEmpleado.txt”, los empleados que no tengan cargado el DNI (DNI en 00).');
	writeln('======================================');
	write('Digite la operacion que desea: ');
	
	readln(opcion);
	writeln('======================================');
	case opcion of
		1: listarNyA(a);
		2: listarEmpleados(a);
		3: listarProximosAJubilacion(a);
		4: addEmpleadosAlFinal(a);
		5: modificarEdadDeEmpleados(a);
		6: exportarATXT(a);
		7: exportarFaltaDni(a);
		0: writeln('Fin del programa');
		else begin 
			writeln('Opcion Incorrecta - Ingrese una correcta()');
			DesplegarMenu(a);
		end;
	end;
	if(opcion <> 0)then 
		DesplegarMenu(a);
end;
var
	a:archivo;
begin
	CrearArchivo(a);
	DesplegarMenu(a);
end.
