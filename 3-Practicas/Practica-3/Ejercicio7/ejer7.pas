program ejer7;

type
    ave = record
        cod:integer;
        nombre:string;
        familia:string;
        descripcion:string;
        zona:string;
    end;

    maestro = file of ave;

{===============================================================================================}

procedure leer_ave(var a:ave);
begin
    with a do begin
        write('Ingresar codigo de ave: ');
        readln(cod);
        if(cod <> 0)then begin
            write('Ingresar nombre del ave: ');
            readln(nombre);
            write('Ingresar familia a la que pertenece el ave: ');
            readln(familia);
            write('Ingresar descripcion del ave: ');
            readln(descripcion);
            write('Ingresar area geografica del ave: ');
            readln(zona);
        end;
    end;
end;

{===============================================================================================}

procedure crear_maestro(var m:maestro);
var
    regm: ave;
begin
    rewrite(m);
    leer_ave(regm);
    while(regm.cod <> 0)do begin
        write(m, regm);
        writeln('-----------------------------------------');
        leer_ave(regm);
    end;
    close(m);
end;

{===============================================================================================}

procedure baja_logica(var mae:maestro; cod:integer);
var
    ok:boolean;
    regm:ave;
begin
    ok:=false;
    reset(mae);
    while(not eof(mae))and(not ok)do begin
        read(mae, regm);
        if(regm.cod = cod)then begin
            regm.cod := -1;
            ok:=true;
            seek(mae, filepos(mae)-1);
            write(mae, regm);
        end;
    end;
    if(ok)then
        writeln('Se hizo la baja logica correctamente.')
    else
        writeln('No se encontro el codigo ingresado.');
    close(mae);
end;

{===============================================================================================}

procedure compactar(var mae:maestro; pos:integer; var cont:integer);
var
    regm : ave;
    last_pos: integer;
begin
    last_pos := filesize(mae)-1;
    seek(mae, (last_pos - cont)); 
    read(mae, regm);               
    seek(mae, pos);
    write(mae, regm);
    cont := cont + 1;    
end;

{===============================================================================================}

procedure eliminar(var mae:maestro);
var
    cod:integer;
    cont:integer;
    regm:ave;
begin
    cont:=0;
    write('Ingrese codigo de ave a eliminar: ');
    readln(cod);
    while(cod <> 0)do begin
        baja_logica(mae, cod);
        writeln('-----------------------------------------');
        write('Ingrese codigo de ave a eliminar: ');
        readln(cod);    
    end;
    reset(mae);
    while(filepos(mae) <> (filesize(mae)-cont))do begin
        read(mae, regm);
        if(regm.cod = -1) then begin
            compactar(mae, (filepos(mae)-1) ,cont);
            seek(mae, filepos(mae)-1);
        end;
    end;
    seek(mae, (filesize(mae)-cont));
    truncate(mae);
    close(mae);
end;

{===============================================================================================}

procedure imprimir(var mae:maestro);
var
    regm:ave;
begin
    reset(mae);
    while(not eof(mae))do begin
        read(mae, regm);
        writeln('cod: ', regm.cod);
    end;
    close(mae);
end;

{===============================================================================================}

var 
    mae: maestro;

begin
    assign(mae, 'maestro');
    crear_maestro(mae);
    writeln('archivo antes de borrar: ');
    imprimir(mae);
    eliminar(mae);
    writeln('archivo despues de borrar: ');
    imprimir(mae);
end.