program ejer15;
const
    number_of_branches = 3;
    high_value = 9999;
type   
    student = record
        dni_student : integer;
        career_cod: integer;
        total_amount_paid : real;
    end;

    payment = record
        dni_student : integer;
        career_cod : integer;
        payment_amount : real;
    end;

    master_file = file of student;

    detail_file = file of payment;

    array_of_details = array [1..number_of_branches] of detail_file;
    array_of_payments = array [1..number_of_branches] of payment;  

{==================================================================================================================}

procedure create_master(var mf: master_file);	
	procedure read_data(var data:student);
	begin
		with data do begin
			write('Enter dni of student: ');
			readln(dni_student);
			if(dni_student <> 0)then begin
				write('Enter career code: ');
				readln(career_cod);
                write('Enter the total amount paid: ');
                readln(total_amount_paid);
			end;
		end;
	end;

var
	d:student;
begin
    writeln('- - - - - - - - READING MASTER FILE - - - - - - - -');
	rewrite(mf);
    writeln('Enter the information ordered by dni of student and career code!');
	read_data(d);
	while(d.dni_student <> 0)do begin
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
	data: payment;
	str_i: string;
begin
	writeln('- - - - - - - - READING DETAIL FILES - - - - - - - -');
	for i:= 1 to number_of_branches do begin

		Str(i, str_i);
		assign(detail[i], 'detail'+str_i);
		rewrite(detail[i]);
		
		{lleno el archivo actual}
		
		writeln('Detail file n°', i, ':');
        writeln('');
		writeln('Enter the information ordered by dni of student and career code!');
		write('Enter dni of student: ');
		readln(data.dni_student);
		while(data.dni_student <> 0)do begin
            write('Enter career code: ');
            readln(data.career_cod);
			write('Enter payment amount: ');
			readln(data.payment_amount);
			
			write(detail[i], data);
            writeln('');
			write('Enter dni of student: ');
		    readln(data.dni_student);
		end;
		close(detail[i]); 
	end;
end;

{==================================================================================================================}

procedure update_master(var master:master_file; var details:array_of_details);
	
	procedure read_file(var f:detail_file; var data:payment);
	begin
    	if (not EOF(f))then 
			read (f, data)
    	else 
			data.dni_student := high_value;
	end;

	procedure minimum(var det_rec:array_of_payments; var min:payment; var deta:array_of_details);
	var 
		i: integer;
		min_student_dni:integer;
		min_pos:integer;
	begin
		{ busco el mínimo elemento del 
			vector reg_det en el campo cod,
			supongamos que es el índice i }
		min_pos := 1;
		min_student_dni:=32767;
		for i:= 1 to number_of_branches do begin    	
			if(det_rec[i].dni_student < min_student_dni)then begin
				min := det_rec[i];
				min_student_dni := det_rec[i].dni_student;
				min_pos := i;
			end;
		end;
		read_file(deta[min_pos], det_rec[min_pos]);
	end;     

{body of update_master}

var
	i:integer;
	min:payment;
	rec_master: student;
	icast:string;
	rec_detail: array_of_payments;
	total_paid: real;
	act_student_dni:integer;
    act_career_code:integer;
begin
	for i:= 1 to number_of_branches do begin
		Str(i,icast);
		assign (details[i], 'detail'+icast); 
		reset( details[i] );
		read_file( details[i],	rec_detail[i]);
	end;

	reset(master);
	minimum(rec_detail, min, details); 
	while (min.dni_student <> high_value) do begin
		total_paid := 0;
		act_student_dni := min.dni_student;
		act_career_code := min.career_cod;

		while(act_student_dni = min.dni_student)and(act_career_code = min.career_cod)do begin
            total_paid := total_paid + min.payment_amount;
			minimum(rec_detail, min, details);
		end;
		
		read(master, rec_master);
		while(rec_master.dni_student <> act_student_dni)do 
			read(master, rec_master);
		rec_master.total_amount_paid := rec_master.total_amount_paid + total_paid;
		seek(master, filepos(master)-1);
		write(master, rec_master);
	end;    
	for i:= 1 to number_of_branches do begin
		close(details[i]);
	end;
	close(master);
end;

{==================================================================================================================}

procedure slow_payers(var master:master_file; var txt:Text);
var 
    data: student;
begin
    reset(master);
    rewrite(txt);
    while(not EOF(master))do begin
        read(master, data);
        if(data.total_amount_paid = 0)then writeln(txt, data.dni_student,' ', data.career_cod, ' "slow payer student" ');
    end;
    close(txt);
    close(master);
end;

{==================================================================================================================}

{main}

var
    master:master_file;
    details:array_of_details;
    txt:Text;
	recM:student;
begin
    assign(master, 'master');
    create_master(master);
    create_details(details);
    
    update_master(master, details);

	reset(master);
	while(not eof(master))do begin
		read(master, recM);
		writeln('dni: ',recM.dni_student,' - career code: ', recM.career_cod,
		' - total amount paid: $',recM.total_amount_paid:2:2);
	end;
	close(master);
    assign(txt, 'slowpayer.txt');
    slow_payers(master, txt);
end.