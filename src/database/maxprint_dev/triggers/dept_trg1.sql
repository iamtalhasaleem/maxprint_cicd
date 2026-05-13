create or replace editionable trigger maxprint_dev.dept_trg1 before
    insert on maxprint_dev.dept
    for each row
begin
    if :new.deptno is null then
        select
            dept_seq.nextval
        into :new.deptno
        from
            sys.dual;

    end if;
end;
/

alter trigger maxprint_dev.dept_trg1 enable;


-- sqlcl_snapshot {"hash":"bbc9619182e5f4a493bcc44b1206ca69c97ee9e1","type":"TRIGGER","name":"DEPT_TRG1","schemaName":"MAXPRINT_DEV","sxml":""}