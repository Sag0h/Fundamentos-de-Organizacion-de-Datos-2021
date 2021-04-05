program ejer10;
const
	valor_alto = 9999;
type
	empleado = record
		depto: integer;
		division: string[3];
		num_emp: integer;
		categoria: 1..15;
		cant_extra: integer;
	end;
	
	archivo = file of empleado;
	
	valor_horas = array [1..15] of real;
	
	
{===================================================================================================================================}

procedure leer_empleado(var datos:empleado);
begin
	with datos do begin
		write('Ingrese depto: ');
		readln(depto);
		if(depto <> 0) then begin
			write('Ingrese division: ');
			readln(division);
			write('Ingrese numero de empleado: ');
			readln(num_emp);
			write('Ingrese categoria: ');
			readln(categoria);
			write('Ingrese cantidad de horas extras realizadas por el empleado: ');
			readln(cant_extra);
		end;
	end;
end;

{==========================================================================================================================================}	

procedure crear_archivo(var a:archivo);
var
	p:empleado;
begin
	writeln('INGRESAR LA INFORMACION ORDENADA POR DEPARTAMENTO, DIVISION Y NUMERO DE EMPLEADO!! ');
	rewrite(a);
	leer_empleado(p);
	while(p.depto <> 0)do begin
		write(a, p);
		leer_empleado(p);
	end;
	close(a);
end;

{===================================================================================================================================}

procedure cargar_valores(var v:valor_horas);
var
	txt:Text;
	i:integer;
begin
	assign(txt, 'valores.txt');
	reset(txt);
	for i:=1 to 15 do 
		readln(txt, v[i]);
	close(txt);
end;

{===================================================================================================================================}

procedure leer(var a:archivo; var dato:empleado);
begin
	if(not eof(a))then
		read(a, dato)
	else
		dato.depto := valor_alto;
end;

{===================================================================================================================================}

procedure listar_info(var a:archivo; v:valor_horas);
var
	regm:empleado;
	
	emp_act:integer;
	extras:integer;
	total_cobra:real;
	
	
	depto_act:integer;
	total_depto:integer;
	monto_depto:real;
	
	div_act:string[3];
	total_div:integer;
	monto_div:real;
	
	
begin
	reset(a);
	leer(a,regm);
	while(regm.depto <> valor_alto)do begin
		writeln('');
		writeln('Departamento: ', regm.depto);

		
		depto_act := regm.depto;
		
		total_depto:= 0;
		monto_depto:= 0;
		
		while(regm.depto = depto_act)do begin	
			writeln('..............................................');
			writeln('Division: ', regm.division);
			writeln('');
			div_act := regm.division;
			total_div := 0;
			monto_div := 0;
			writeln('Numero de Empleado:        Total de Hs.:         Importe a cobrar:');
			writeln('');
			while(regm.depto = depto_act)and(regm.division = div_act)do begin
				total_cobra := 0;
				emp_act:= regm.num_emp;
				extras := 0;
				
				while(emp_act = regm.num_emp)and(regm.division = div_act)and(regm.depto = depto_act)do begin
					total_cobra := total_cobra + (regm.cant_extra * v[regm.categoria]);
					extras := extras + regm.cant_extra;
					leer(a, regm);
				end;
				total_div := total_div + extras;
				
				writeln(emp_act, '                          ', extras,'                     $', total_cobra:2:2);
				writeln('');
				monto_div:=monto_div + total_cobra;
			end;
			writeln('Total de horas division: ', total_div);
			writeln('Monto total por Division: $', monto_div:2:2);
			
			total_depto := total_depto + total_div;
			monto_depto := monto_depto + monto_div;
		end;
		writeln('');
		writeln('Total horas departamento: ', total_depto);
		writeln('Monto total departamento: $', monto_depto:2:2);
	end;
	close(a);
end;

{===================================================================================================================================}

{MAIN}

var
	a:archivo;
	valores: valor_horas;
begin
	assign(a, 'archivo');
	crear_archivo(a);
	cargar_valores(valores);
	listar_info(a, valores);
end.
