alter table maxprint_dev.job_history
    add constraint jhist_emp_fk
        foreign key ( employee_id )
            references maxprint_dev.employees ( employee_id )
        enable;


-- sqlcl_snapshot {"hash":"1eb29272076ab05d64e581d428db34df5310d31b","type":"REF_CONSTRAINT","name":"JHIST_EMP_FK","schemaName":"MAXPRINT_DEV","sxml":""}