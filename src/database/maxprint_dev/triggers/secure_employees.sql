create or replace editionable trigger maxprint_dev.secure_employees before
    insert or update or delete on maxprint_dev.employees
begin
    secure_dml;
end secure_employees;
/

alter trigger maxprint_dev.secure_employees disable;


-- sqlcl_snapshot {"hash":"79dc4d98e382cf089c00126c25bc6baa7e71b5ea","type":"TRIGGER","name":"SECURE_EMPLOYEES","schemaName":"MAXPRINT_DEV","sxml":""}