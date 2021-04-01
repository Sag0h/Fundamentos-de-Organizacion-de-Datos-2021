program ejemplo_3_7;
const 
	valoralto=”ZZZ”;
type 
	nombre = string[30];
	RegVenta = record
		 Vendedor: integer;
		 MontoVenta: real;
		 Sucursal: nombre;
		 Ciudad: nombre;
		 Provincia: nombre;		
	end;
	Ventas = file of RegVenta;
var
	reg: RegVenta;
	archivo: Ventas;
	total, totprov, totciudad, totsuc: integer;
	prov, ciudad, sucursal: nombre;

procedure leer (var archivo: Ventas; var dato:RegVenta);
begin
	if (not eof(archivo)) then
		read (archivo,dato)
	else
		dato.provincia:= valoralto;
end;

{programa principal}
begin
	assign (archivo, ‘archivoventas’);
	reset (archivo);
	leer(archivo, reg);
	total:= 0;
	while (reg.Provincia <> valoralto) do
	begin
		writeln(“Provincia:”, reg.Provincia);
		prov := reg.Provincia;
		totprov := 0;
		while (prov=reg.Provincia)do
		begin
			writeln(“Ciudad:”, reg.Ciudad);
			ciudad := reg.Ciudad;
			totciudad := 0
			while (prov=reg.Provincia) and (Ciudad=reg.Ciudad)do
			Begin
				writeln(“Sucursal:”, reg.Sucursal);
				sucursal := regSucursal;
				totsuc := 0;
				while ((prov=reg.Provincia) and (Ciudad=reg.Ciudad) and (Sucursal=regSucursal)) do
				Begin
					write(“Vendedor:”, reg.Vendedor);
					writeln(reg.MontoVenta);
					totsuc := totsuc + reg.MontoVenta;
			 		leer(archivo, reg);
		
				end;
				writeln(“Total Sucursal”, totsuc);
				totciudad := totciudad + totsuc;
			end;
			writeln(“Total Ciudad”, totciudad);
			totprov := totprov + totciudad;
		end;
		writeln(“Total Provincia”, totprov);
		total := total + totprov,
	end;
	writeln(“Total Empresa”, total);
	close (archivo);
end.	
