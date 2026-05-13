alter table maxprint_dev.employees
    add constraint emp_manager_fk
        foreign key ( manager_id )
            references maxprint_dev.employees ( employee_id )
        enable;


-- sqlcl_snapshot {"hash":"3907c9f6555261dff9f3be9b78a7be5c1700f8c3","type":"REF_CONSTRAINT","name":"EMP_MANAGER_FK","schemaName":"MAXPRINT_DEV","sxml":""}