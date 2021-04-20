program ejer18;
const
    high_value = 'zzzzz';
type

    calendar = record
		y : integer;
		m : 1..12;
		d : 1..31;
	end;

    event = record
        event_name : string[30];
        function_date : calendar;
        sector : string;
        sold_tickets : integer;
    end;

    master_file = file of event;

{==================================================================================================================}

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
	procedure read_data(var data:event);
	begin
		with data do begin
			write('Enter event name: ');
			readln(event_name);
			if(event_name <> '0')then begin
                writeln('Enter function date: ');
                read_date(function_date);
				write('Enter name sector: ');
				readln(sector);
    			write('Enter number of tickets sold: ');
				readln(sold_tickets);
			end;
		end;
	end;

var
	d:event;
begin
    writeln('- - - - - - - - READING MASTER FILE - - - - - - - -');
	rewrite(mf);
    writeln('Enter the information ordered by event name and function date!');
	read_data(d);
	while(d.event_name <> '0')do begin
		writeln('');
        write(mf, d);
		read_data(d);
	end;
	close(mf);
end;

{==================================================================================================================}

procedure read_file(var master:master_file; var data:event);
begin
    if(not eof(master))then
        read(master, data)
    else
        data.event_name := high_value;
end;


procedure show_report(var master:master_file);
var
    count_e:integer;
    count_f:integer;
    count_s:integer;

    rec_m:event;
    total_sold:integer;
    total_sold_event:integer;
    act_event_date : calendar;
    act_event_name : string[30];
begin
    writeln('NUMBER OF TICKETS SOLD BY FUNCTION AND BY EVENT:');
    writeln('');
    reset(master);
    
    count_e := 0;
    read_file(master, rec_m);
    while(rec_m.event_name <> high_value)do begin
        act_event_name := rec_m.event_name;
        total_sold_event := 0;
        count_e := count_e + 1;
        writeln('EVENT NAME: ', act_event_name,' - EVENT ', count_e);
        writeln('');
        count_f := 0;
        while(rec_m.event_name = act_event_name)do begin
            count_f := count_f + 1;
            act_event_date := rec_m.function_date;
            writeln('   FUNCTION DATE: ', act_event_date.y,'/',act_event_date.m,'/',act_event_date.d,
            ' - FUNCTION ', count_f);
            total_sold:=0;
            count_s := 0;
            while(rec_m.event_name = act_event_name)and(rec_m.function_date.y = act_event_date.y)and
            (rec_m.function_date.m = act_event_date.m)and(rec_m.function_date.d = act_event_date.d)do begin
                count_s := count_s + 1;
                total_sold := total_sold + rec_m.sold_tickets;
                writeln('       Sector ', count_s ,': ', rec_m.sector,'       ',
                'Number of tickets sold: ', rec_m.sold_tickets);
                read_file(master, rec_m)
            end;
            writeln('   ---------------------------------------------------------------');
            writeln('   Total number of tickets sold by function ', count_f,': ', total_sold);
            writeln('');
            total_sold_event := total_sold_event + total_sold;
        end;
        writeln('------------------------------------------------------------------');
        writeln('Total number of tickets sold by event ', count_e,': ', total_sold_event);
        writeln('');
    end;
    close(master);
end;
 
{==================================================================================================================}

{main}

var
    master : master_file;
begin
    assign(master,'master');
    create_master(master);
    show_report(master);
end.