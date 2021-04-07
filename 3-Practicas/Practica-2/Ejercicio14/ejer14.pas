program ejer14;
const
	high_value = 'zzzzz';
	phy_dim = 2;
type

	calendar = record
		y : 2000..2100;
		m : 1..12;
		d : 1..31;
	end;

	schedule = record
		h : 0..23;
		m : 0..59;
	end;
	
	flight = record
		destination : string[15];
		date : calendar;
		departure_time : schedule;
		available_seats : integer;
	end;

	master_file = file of flight;
	
	update = record
		destination : string[15];
		date : calendar;
		departure_time : schedule;
		sold_seats : integer;
	end;
	
	detail_file = file of update;
	
	array_detail_files = array[1..phy_dim] of detail_file;

	detail_rec = array[1..phy_dim] of update;

{==================================================================================================================}

procedure read_flight_date(var date: calendar);
begin
	write('Enter year: ');
	readln(date.y);
	write('Enter month: ');
	readln(date.m);
	write('Enter day: ');
	readln(date.d);
end;

{==================================================================================================================}

procedure read_d_time(var t: schedule);
begin
	write('Enter hour: ');
	readln(t.h);
	write('Enter minutes: ');
	readln(t.m);
end;

{==================================================================================================================}

procedure create_master(var mf: master_file);	
	procedure read_data(var data:flight);
	begin
		with data do begin
			write('Enter destination: ');
			readln(destination);
			if(destination <> '0')then begin
				read_flight_date(date);
				read_d_time(departure_time);
				write('Enter number of available seats: ');
				readln(available_seats);
			end;
		end;
	end;

var
	d:flight;
begin
	rewrite(mf);
	read_data(d);
	while(d.destination <> '0')do begin
		write(mf, d);
		read_data(d);
	end;
	close(mf);
end;

{==================================================================================================================}

procedure create_details(var detail: array_detail_files);

var
	i: integer;
	data: update;
	str_i: string;
begin
	writeln('- - - - - - - - READING DETAIL FILES - - - - - - - -');
	for i:= 1 to phy_dim do begin

		Str(i, str_i);
		assign(detail[i], 'detail'+str_i);
		rewrite(detail[i]);
		
		{lleno el archivo actual}
		
		writeln('Detail file n°', i, ':');
		writeln('Enter the information ordered by destination, date and time of departure: ');
		write('Enter destination: ');
		readln(data.destination);
		while(data.destination <> '0')do begin
			read_flight_date(data.date);
			read_d_time(data.departure_time);
			write('Enter the number of sold seats: ');
			readln(data.sold_seats);
			
			write(detail[i], data);

			write('Enter destination: ');
			readln(data.destination);
		end;
		close(detail[i]); {cierro el actual}
	end;
end;

{==================================================================================================================}

procedure update_master(var master:master_file; var details:array_detail_files);
	
	procedure read_file(var f:detail_file; var data:update);
	begin
    	if (not eof(f))then 
			read (f, data)
    	else 
			data.destination := high_value;
	end;

	procedure minimum(var det_rec:detail_rec; var min:update; var deta:array_detail_files);
	var 
		i: integer;
		min_destination:string;
		min_pos:integer;
	begin
		{ busco el mínimo elemento del 
			vector reg_det en el campo cod,
			supongamos que es el índice i }
		min_pos := 1;
		min_destination:='zzzzzzzz';
		for i:= 1 to phy_dim do begin    	
			if(det_rec[i].destination < min_destination)then begin
				min := det_rec[i];
				min_destination := det_rec[i].destination;
				min_pos := i;
			end;
		end;
		read_file(deta[min_pos], det_rec[min_pos]);
		
	end;     

{body of update_master}

var
	i:integer;
	min:update;
	rec_master: flight;
	icast:string;
	rec_detail: detail_rec;
	total_sold: integer;
	act_date: calendar;
	act_dtime: schedule;
	act_destination: string;
begin
	for i:= 1 to phy_dim do begin
		Str(i,icast);
		assign (details[i], 'detail'+icast); 
		reset( details[i] );
		read_file( details[i],	rec_detail[i]);
	end;
	
	reset(master);
	minimum(rec_detail, min, details); {busco el detalle minimo}
	while (min.destination <> high_value) do begin
		total_sold := 0;
		act_destination := min.destination;
		act_date := min.date;
		act_dtime := min.departure_time;
		
		while(act_destination = min.destination)and(act_date.y = min.date.y)and
		(act_date.m = min.date.m)and(act_date.d = min.date.d)and(act_dtime.h = min.departure_time.h)and
		(act_dtime.m = min.departure_time.m)do begin
			
			total_sold := total_sold + min.sold_seats;
			minimum(rec_detail, min, details);
		end;
		
		read(master, rec_master);
		while(rec_master.destination <> act_destination)do 
			read(master, rec_master);
		rec_master.available_seats := rec_master.available_seats - total_sold;
		seek(master, filepos(master)-1);
		write(master, rec_master);
	end;    
	for i:= 1 to phy_dim do begin
		close(details[i]);
	end;
	close(master);
end;

{==================================================================================================================}

procedure generate_list(var master:master_file; var list_flights:Text; amount:integer);
var
	master_rec : flight;
begin
	rewrite(list_flights);
	reset(master);
	while(not EOF(master))do begin
		read(master, master_rec);
		if(master_rec.available_seats < amount)then
			writeln(list_flights,'Destination: ',master_rec.destination, ' - Date:',master_rec.date.y,'/',
			master_rec.date.m,'/',master_rec.date.d,' <-(y-m-d) - Departure time: ', master_rec.departure_time.h, ':', master_rec.departure_time.m);
	end;
	close(list_flights);
	close(master);
end;

{==================================================================================================================}

{main}

var 
	master:master_file;
	detail:array_detail_files;
	amount:integer;
	list_flights:Text;
begin
	assign(master, 'master');
	create_master(master);
	create_details(detail);

	update_master(master, detail);
	write('Enter a number of available seats: ');
	readln(amount);
	assign(list_flights, 'list.txt');
	generate_list(master, list_flights, amount);
end.	
