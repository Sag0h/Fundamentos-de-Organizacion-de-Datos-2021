program ejer16;
const
    detail_files_amount = 1;
    high_value = 9999;
type

    calendar = record
		y : integer;
		m : 1..12;
		d : 1..31;
	end;

    emission = record
        date : calendar;
        weekly_code : integer;
        weekly_name : string[30];
        description : string;
        price : real;
        total_copies : integer;
        total_copies_sold : integer;
    end;

    master_file = file of emission;

    update = record
        date : calendar;
        weekly_code : integer;
        copies_sold : integer;
    end;

    detail_file = file of update;

    array_of_details = array [1..detail_files_amount] of detail_file;
    array_of_updates = array [1..detail_files_amount] of update;

{=================================================================================================================}

procedure read_date(var date: calendar);
begin
	write('Enter year: ');
	readln(date.y);
    if(date.y <> 0)then begin
        write('Enter month: ');
        readln(date.m);
        write('Enter day: ');
        readln(date.d);
    end;
end;


procedure create_master(var mf: master_file);	
	procedure read_data(var data:emission);
	begin
		with data do begin
			read_date(date);
			if(date.y <> 0)then begin
				write('Enter weekly code: ');
				readln(weekly_code);
                write('Enter weekly name: ');
                readln(weekly_name);
				write('Enter the weekly description: ');
				readln(description);
                write('Enter weekly price: ');
                readln(price);
    			write('Enter total copies: ');
				readln(total_copies);
                write('Enter total copies sold: ');
                readln(total_copies_sold);
			end;
		end;
	end;

var
	d:emission;
begin
    writeln('- - - - - - - - READING MASTER FILE - - - - - - - -');
	rewrite(mf);
    writeln('Enter the information ordered by date and weekly code!');
	read_data(d);
	while(d.date.y <> 0)do begin
		writeln('');
        write(mf, d);
		read_data(d);
	end;
	close(mf);
end;

{==================================================================================================================}

procedure create_details(var detail:array_of_details);
var
	i: integer;
	data: update;
	str_i: string;
begin
	writeln('- - - - - - - - READING DETAIL FILES - - - - - - - -');
	for i:= 1 to detail_files_amount do begin

		Str(i, str_i);
		assign(detail[i], 'detail'+str_i);
		rewrite(detail[i]);
		
		{lleno el archivo actual}
		
		writeln('Detail file n°', i, ':');
        writeln('');
        writeln('Enter the information ordered by date and weekly code!');
		read_date(data.date);
		while(data.date.y <> 0)do begin
            write('Enter weekly code: ');
            readln(data.weekly_code);
			write('Enter the number of copies sold: ');
			readln(data.copies_sold);
			
			write(detail[i], data);
            writeln('');
			read_date(data.date);
		end;
		close(detail[i]); 
	end;
end;

{==================================================================================================================}

procedure update_master(var master:master_file; var details:array_of_details);
    

	procedure read_file(var f:detail_file; var data:update);
	begin
    	if (not EOF(f))then 
			read (f, data)
    	else 
			data.date.y := high_value;
	end;

	procedure minimum(var det_rec:array_of_updates; var min:update; var deta:array_of_details);
	var 
		i: integer;
		min_year:integer;
		min_pos:integer;
	begin
		{ busco el mínimo elemento del 
			vector reg_det en el campo cod,
			supongamos que es el índice i }
		min_pos := 1;
		min_year:=32767;
		for i:= 1 to detail_files_amount do begin    	
			if(det_rec[i].date.y < min_year)then begin
				min := det_rec[i];
				min_year := det_rec[i].date.y;
				min_pos := i;
			end;
		end;
		read_file(deta[min_pos], det_rec[min_pos]);
	end;     

{body of update_master}

var
	i:integer;
	min:update;
	rec_master:emission;
	icast:string;
	rec_detail: array_of_updates;
	total_sold: integer;
	
    act_year:integer;
    act_month:integer;
    act_day:integer;

    act_weekly_code:integer;

    
    
begin
    for i:= 1 to detail_files_amount do begin
		Str(i,icast);
		assign (details[i], 'detail'+icast); 
		reset( details[i] );
		read_file( details[i],	rec_detail[i]);
	end;

	reset(master);
	minimum(rec_detail, min, details); 
	while (min.date.y <> high_value) do begin
		total_sold := 0;
		act_year := min.date.y;
        act_month := min.date.m;
        act_day := min.date.d;
		act_weekly_code := min.weekly_code;

		while(act_year = min.date.y)and(act_month = min.date.m)and(act_day = min.date.d)and
        (act_weekly_code = min.weekly_code)do begin
            total_sold := total_sold + min.copies_sold;
			minimum(rec_detail, min, details);
		end; 

		read(master, rec_master);
		while(rec_master.date.y <> act_year)do 
			read(master, rec_master);
		rec_master.total_copies_sold := rec_master.total_copies_sold + total_sold;
		seek(master, filepos(master)-1);
		write(master, rec_master);
	end;    
	for i:= 1 to detail_files_amount do begin
		close(details[i]);
	end;
	close(master); 
end;

{==================================================================================================================}

procedure init_max_and_min(var max:emission; var min:emission);
begin
    max.total_copies_sold := -1;
    min.total_copies_sold := 32767;
end;


procedure max_and_min(var master:master_file;var max_sales:emission; var min_sales:emission);
var
    rec_master : emission;
begin
    reset(master);
    while(not eof(master))do begin
        read(master, rec_master);
        if(rec_master.total_copies_sold >= max_sales.total_copies_sold)then 
            max_sales := rec_master
        else 
            if(rec_master.total_copies_sold <= min_sales.total_copies_sold)then
                min_sales := rec_master; 
                
    end;
    close(master);
    
    {I print on screen the maximum and minimum}

     writeln('The weekly with the most sales was "', max_sales.weekly_name, '" - weekly code:', max_sales.weekly_code,
    ' - date: ',max_sales.date.y, '/',max_sales.date.m,'/',max_sales.date.d);
   
    writeln('The weekly with the least sales was "', min_sales.weekly_name, '" - weekly code:', min_sales.weekly_code,
    ' - date: ',min_sales.date.y, '/',min_sales.date.m,'/',min_sales.date.d);

end;

{==================================================================================================================}

{main}

var
    master:master_file;
    details:array_of_details;
    max:emission;
    min:emission;
begin
    assign(master, 'master');
    create_master(master);
    create_details(details);
    update_master(master, details);
    init_max_and_min(max,min);
    max_and_min(master, max, min);
end.