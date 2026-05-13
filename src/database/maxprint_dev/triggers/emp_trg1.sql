create or replace editionable trigger maxprint_dev.emp_trg1 before
    insert on maxprint_dev.emp
    for each row
begin
    if :new.empno is null then
        select
            emp_seq.nextval
        into :new.empno
        from
            sys.dual;

    end if;
end;
/

alter trigger maxprint_dev.emp_trg1 enable;


-- sqlcl_snapshot {"hash":"a51cc8e978e26061efb25ce9717f7572d84b9327","type":"TRIGGER","name":"EMP_TRG1","schemaName":"MAXPRINT_DEV","sxml":""}