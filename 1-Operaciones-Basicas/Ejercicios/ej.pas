program ejercicio1;
type 
    Archivodenumeros = file of integer;

var
    archivo: Archivodenumeros;
    Arch: String;
    num: integer;
begin
    write('Ingrese nombre del archivo a generar: ');
    readln(Arch);
    Assign(archivo, Arch);

    rewrite(archivo);

    write('Ingrese un numero: ');
    readln(num);

    while(num <> 0)do begin
        write(archivo, num);
        
        write('Ingrese un numero: ');
        readln(num);
    end;

    close(archivo);
end.