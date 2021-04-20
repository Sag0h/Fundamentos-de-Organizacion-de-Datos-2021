program ejer4;
uses SysUtils;
type
    
    tTitulo = String[50];
    
    tArchRevistas = file of tTitulo ;

procedure crear_archivo(var f:tArchRevistas);
var
    str_aux:tTitulo;
begin
    rewrite(f);
    write(f, '0');
    write('Ingrese un string: ');
    readln(str_aux);
    while(str_aux <> 'fin')do begin
        write(f, str_aux);
        write('Ingrese un string: ');
        readln(str_aux);
    end;
    close(f);
end;

procedure dar_alta(var f:tArchRevistas; t:tTitulo);
var
    pos:integer;
    titulo:tTitulo;
begin
    reset(f);
    if(not eof(f))then
        read(f,titulo);
    if(titulo <> '0')then begin
        pos := StrToInt(titulo);
        seek(f, pos); {voy a la posicion que esta indicada en la head}
        read(f,titulo); {leo el dato de la posicion para ver el proximo lugar borrado}

        seek(f, filepos(f)-1); { voy a la posicion para escribir el nuevo valor}
        write(f, t); {doy el alta}
        
        {voy al head y pongo el valor que estaba en la posicion que acabo de escribir}
        seek(f, 0);
        write(f, titulo);
    end
    else begin
        {si la head es 0 entonces doy alta al final}
        seek(f, filesize(f));
        write(f, t);       
    end;
    writeln('Se dio de alta con exito!');
    close(f);
end;

procedure dar_baja(var f: tArchRevistas; t:tTitulo);
var
    titulo:tTitulo;
    head:string;
begin
    reset(f);
    read(f, titulo);
    head := titulo;
    while(not eof(f))and(titulo <> t)do
        read(f,titulo);
    if(titulo = t)then begin
        titulo := head; {head ahora vale lo que head}
        seek(f, filepos(f)-1);{vamos a la posicion de t}
        Str(filepos(f), head); {ponemos la posicion de t en head} 
        write(f, titulo); {escribimos en el archivo en posicion t}
        seek(f, 0); {vamos a la head}
        write(f, head); {ponemos el valor de la posicion t (registro borrado) en la head}
        writeln('Se hizo la baja logica con exito!');
    end
    else
        writeln('No se encontro el valor a eliminar en el archivo.');
    close(f);
end;

function ValorEntero(texto: string): integer;
var
    valor, codigoDeError: integer;
begin
    valor := 0;
    val(texto, valor, codigoDeError);
    ValorEntero := codigoDeError;
end;

procedure listar(var f:tArchRevistas);
var
    t:tTitulo;
begin
    reset(f);
    read(f, t);

    while(not eof(f))do begin
        read(f, t);
        if(ValorEntero(t) <> 0)then 
            writeln(t);
    end;    
    close(f);
end;


var
    t:tTitulo;
    file_str:tArchRevistas;
begin
    assign(file_str, 'archivo');
    crear_archivo(file_str);
    listar(file_str);

    write('Ingrese un titulo para dar de baja: ');
    readln(t);
    dar_baja(file_str,t);
    listar(file_str);

    write('Ingrese un titulo para dar de alta: ');
    readln(t);
    dar_alta(file_str,t);

    listar(file_str);
end.