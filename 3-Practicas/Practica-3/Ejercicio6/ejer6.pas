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

    master_file = file of article;

    detail_file = file of integer;

{===============================================================================================}

procedure read_art(var a: article);
begin
    with a do begin
        write('Enter the article code: ');
        readln(cod);
        if(cod <> 0)then begin
            write('Enter the article description: ');
            readln(desc);
            write('Enter article colours: ');
            readln(colours);
            write('Enter article type: ');
            readln(type_garment);
            write('Enter the actual stock: ');
            readln(stock);
            write('Enter article price: ');
            readln(unit_price);          
        end;
    end;
end;

{===============================================================================================}

procedure create_master(var master:master_file);
var
    rec: article;
begin
    rewrite(master);
    read_art(rec);
    while(rec.cod <> 0)do begin
        write(master, rec);
        read_art(rec);
    end;
    close(master);
end;

{===============================================================================================}

procedure create_detail(var d:detail_file);
var
    cod:integer;
begin
    rewrite(d);
    writeln('Enter the code of the garments that will be obsolete:');
    write('article code: ');
    readln(cod);
    while(cod <> 0)do begin
        write(d,cod);
        write('article code: ');
        readln(cod);
    end;
    close(d);
end;

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
        while(not eof(master))do begin
            read(master, rec_m);
            if(rec_m.cod = cod_act)then begin
                rec_m.stock := -1;
                seek(master, filepos(master)-1);
                write(master, rec_m);
            end;
        end;
        seek(master,0); 
    end;
    close(master);
    close(detail);
end;

{===============================================================================================}

procedure compact(var master:master_file; var new_m:master_file);
var
    rec_m:article;
begin
    reset(master);
    rewrite(new_m);
    while(not eof(master))do begin
        read(master, rec_m);
        if(rec_m.stock >= 0)then
            write(new_m, rec_m);
    end;
    close(new_m);
    close(master);
    erase(master);
    rename(new_m, 'master');
end;

{===============================================================================================}

{Main}
var 
    f_new,master:master_file;
    detail:detail_file;
begin
    assign(master, 'master');
    create_master(master);
    assign(detail, 'detail');
    create_detail(detail);
    update_master(master, detail);
    assign(f_new,'aux_file');
    compact(master,f_new); 
end.