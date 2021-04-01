program ejemplo_3_6;
const 
	valoralto=’9999’;

type 
	str4 = string[4];
	
	producto = record
		codigo: str4;
		nombre: string[30];
		cant: integer;		
	end;
	
	detalle = file of producto;

var
	min, regd1, regd2, regd3, regmae: ventas;
	det1, det2, det3, mae1: detalle;
	codprod: str4;
	cantotal: integer;

procedure leer (var archivo:detalle; var dato:producto);
begin
if (not eof(archivo)) then
	read (archivo,dato)
else
	codigo:= valoralto;
end;

procedure minimo (var r1,r2,r3,min:producto);
begin
	if (r1.codigo<=r2.codigo) and (r1.cod<=r3.codigo) then begin
		min := r1;
		leer(det1,r1);
	end
	else
		if (r2.codigo<=r3.codigo)then begin
			min := r2;
			leer(det2,r2);
		end
		else
			begin
				min := r3;
				leer(det3,r3)
			end;
end;

{programa principal}
begin
	assign (mae1, ‘maestro’);
	assign (det1, ‘detalle1’);
	assign (det2, ‘detalle2’);
	assign (det3, ‘detalle3’);
	rewrite (mae1);
	reset (det1);
	reset (det2);
	reset (det3);
	leer(det1, regd1);
	leer(det2, regd2);
	leer(det3, regd3);
	minimo(regd1,regd2,regd3,min);
	{se procesan todos los registros de los archivos detalle}
	while (min.codigo <> valoralto) do
	begin
		codprod := min.codigo;
		cantotal := 0;
		{se procesan todos los registros del mismo producto}
		while (codprod=min.codigo)
		begin			
			cantotal:= cantotal + min.cant;		
			minimo(regd1,regd2,regd3,min);
		end;
		write(mae1, min);
	end;
	close(det1);
	close(det2);
	close(det3);
	close(mae1);
end. 


