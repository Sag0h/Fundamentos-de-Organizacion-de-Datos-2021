program ejer2;
const
    dni_min = 8000000;
type

    employee = record
        emp_cod : integer;
        last_name : string[20];
        first_name : string[20];
        address : string[50];
        phone : string[20];
        dni : Longint;
        birth_date : string;
    end;

    emp_file = file of employee;

procedure logical_deletion(var f:emp_file);
var
    emp : employee;
begin
    reset(f);
    while(not eof(f))do begin
        read(f, emp);
        if(emp.dni < dni_min)then begin
            emp.first_name := '*' + emp.first_name;
            seek(f, filepos(f)-1);
            write(f, emp);
        end;
    end;
    close(f);
end;

procedure create_file(var f:emp_file);
    procedure read_emp(var e:employee);
    begin
        with e do begin
            write('Enter employee code: ');
            readln(emp_cod);
            if(emp_cod <> 0)then begin
                write('Enter the employee last name: ');
                readln(last_name);
                write('Enter the employee'+Chr(39)+'s name: '); {trying to print an ' by his ascii value '=39}
                readln(first_name);
                write('Enter the employee'+Chr(39)+'s address: ');
                readln(address);
                write('Enter the employee'+Chr(39)+'s phone: ');
                readln(phone);
                write('Enter the employee'+Chr(39)+'s D.N.I: ');
                readln(dni);
                write('Enter the employee'+Chr(39)+'s date of birth: ');
                readln(birth_date);
            end;
        end;
    end;

var
    e:employee;
begin
    rewrite(f);
    read_emp(e);
    while(e.emp_cod <> 0)do begin
        write(f, e);
        read_emp(e);
    end;
    close(f);
end;

{main}
var
    employees_file : emp_file;
begin
    assign(employees_file, 'employees');
    create_file(employees_file);
    logical_deletion(employees_file);
    {I already checked that it works}
end.