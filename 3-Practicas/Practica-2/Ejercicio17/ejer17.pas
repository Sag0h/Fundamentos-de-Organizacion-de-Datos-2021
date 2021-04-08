program ejer17;
const
    amount_of_details = 2;
    high_value = 9999;
type
    vehicle = record
        vcode : integer;
        vname : string[30];
        description : string;
        model : string[30];
        actual_stock : integer;
    end;

    master_file = file of vehicle;

    calendar = record
		y : integer;
		m : 1..12;
		d : 1..31;
	end;

    sale = record
        vcode : integer;
        price : real;
        sale_date : calendar;
    end;

    detail_file = file of sale;

    array_of_sales = array [1..amount_of_details] of sale;
    array_of_details = array [1..amount_of_details] of detail_file;

{=================================================================================================================}

procedure read_date(var date: calendar);
begin
	write('Enter year: ');
	readln(date.y);
    write('Enter month: ');
    readln(date.m);
    write('Enter day: ');
    readln(date.d);
end;


procedure create_master(var mf: master_file);	
	procedure read_data(var data:vehicle);
	begin
		with data do begin
			write('Enter vehicle code: ');
			readln(vcode);
			if(vcode <> 0)then begin
                write('Enter vehicle name: ');
                readln(vname);
				write('Enter the vehicle description: ');
				readln(description);
    			write('Enter vehicle model: ');
				readln(model);
                write('Enter actual vehicle stock: ');
                readln(actual_stock);
			end;
		end;
	end;

var
	d:vehicle;
begin
    writeln('- - - - - - - - READING MASTER FILE - - - - - - - -');
	rewrite(mf);
    writeln('Enter the information ordered by vehicle code!');
	read_data(d);
	while(d.vcode <> 0)do begin
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
	data: sale;
	str_i: string;
begin
	writeln('- - - - - - - - READING DETAIL FILES - - - - - - - -');
	for i:= 1 to amount_of_details do begin

		Str(i, str_i);
		assign(detail[i], 'detail'+str_i);
		rewrite(detail[i]);
		
		{lleno el archivo actual}
		
		writeln('Detail file n°', i, ':');
        writeln('');
        writeln('Enter the information ordered by vehicle code!');
        write('Enter vehicle code: ');
        readln(data.vcode);
		while(data.vcode <> 0)do begin
			write('Enter vehicle price: ');
			readln(data.price);
            writeln('Enter sale date: ');    
       		read_date(data.sale_date);
		
        	write(detail[i], data);
            writeln('');
            write('Enter vehicle code: ');
            readln(data.vcode);
		end;
		close(detail[i]); 
	end;
end;

{==================================================================================================================}

procedure update_master(var master:master_file; var details:array_of_details);
	
    procedure read_file(var f:detail_file; var data:sale);
	begin
    	if (not EOF(f))then 
			read (f, data)
    	else 
			data.vcode := high_value;
	end;

	procedure minimum(var det_rec:array_of_sales; var min:sale; var deta:array_of_details);
	var 
		i: integer;
		min_vcode:integer;
		min_pos:integer;
	begin
		{ busco el mínimo elemento del 
			vector reg_det en el campo cod,
			supongamos que es el índice i }
		min_pos := 1;
		min_vcode:=32767;
		for i:= 1 to amount_of_details do begin    	
			if(det_rec[i].vcode < min_vcode)then begin
				min := det_rec[i];
				min_vcode := det_rec[i].vcode;
				min_pos := i;
			end;
		end;
		read_file(deta[min_pos], det_rec[min_pos]);
	end;     

{body of update_master}

var
	i:integer;
	min:sale;
	rec_master:vehicle;
	icast:string;
	rec_detail: array_of_sales;

	total_sold: integer;

    act_vcode:integer;
    most_sold: vehicle;
    max : integer;
begin
    max:= -1;
    for i:= 1 to amount_of_details do begin
		Str(i,icast);
		assign (details[i], 'detail'+icast); 
		reset( details[i] );
		read_file( details[i],	rec_detail[i]);
	end;

	reset(master);
	minimum(rec_detail, min, details); 
	while (min.vcode <> high_value) do begin
		total_sold := 0;

		act_vcode := min.vcode;

		while(act_vcode = min.vcode)do begin
            total_sold := total_sold + 1;
			minimum(rec_detail, min, details);
		end; 

		read(master, rec_master);
		while(rec_master.vcode <> act_vcode)do 
			read(master, rec_master);
		rec_master.actual_stock := rec_master.actual_stock - total_sold;
        if(total_sold >= max)then begin
            max := total_sold;
            most_sold := rec_master;
        end;
		seek(master, filepos(master)-1);
		write(master, rec_master);
	end;    
	for i:= 1 to amount_of_details do begin
		close(details[i]);
	end;
	close(master); 

    writeln('The most sold vehicle was ', most_sold.vname, ' ', most_sold.model);
end;

{==================================================================================================================}

{main}

var
    master: master_file;
    details: array_of_details;
begin
    assign(master, 'master');
    create_master(master);
    create_details(details);
    update_master(master,details);

end.