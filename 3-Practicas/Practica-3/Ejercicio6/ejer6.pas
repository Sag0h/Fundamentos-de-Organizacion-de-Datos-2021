program ejer6;

type

    article = record
	    cod:integer;
		desc:string[25];
		colours:string[10];
        type_garment : string[20];
		stock:integer;
		unit_price:real;
	end;

    master_file = file of articulo()

    detail_file = file of integer;

{===============================================================================================}

procedure update_master(var master:master_file; var detail:detail_file);
var
    cod_act : integer;
    rec_m : article;
begin
    reset(detail);
    reset(master);    
    while(not eof(detail))do begin   
        read(detail, cod_act);
        while(not eof(master)do begin
            read(master, rec_m);
            if(rec_m.cod = cod_act)then begin
                rec_m.stock := -1;
                seek(master, filepos(master)-1);
                write(master, rec_m);
            end;
        end;)
        seek(master,0); 
        // preguntar a un ayudante que es mejor:
        // hacer muchos reset y close 
        // o hacer seeks al primer elemento
    end;
    close(master);
    close(detail);
end;

{===============================================================================================}

procedure compact(var master:master_file);
var

begin
    
end;

{===============================================================================================}

{Main}
var 
    master:master_file;
    detail:detail_file;
begin
    assign(master, 'master');
    create_masterfile(master);
    assign(detail, 'detail');
    create_detailfile(detail);
    update_master(master, detail);
    compact(master); // no lo se hacer, no entiendo que quiere el enunciado
    
end.