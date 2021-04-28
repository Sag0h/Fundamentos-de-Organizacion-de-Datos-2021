program ejer1;
const 
    M = 4; 
type

    doctor = record
        first_name : string[15];
        last_name : string[15];
        dni : integer;
        license : integer;
        income_year : integer;
    end;

    node = record
        keys_amount: integer;
        keys: array[1..(M-1)] of doctor;
        childrens : array[1..M] of integer;
    end;

    tree = file of node;





var

begin
    
end.