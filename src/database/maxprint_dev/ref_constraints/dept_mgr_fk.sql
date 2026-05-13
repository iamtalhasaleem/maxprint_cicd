alter table maxprint_dev.departments
    add constraint dept_mgr_fk
        foreign key ( manager_id )
            references maxprint_dev.employees ( employee_id )
        enable;


-- sqlcl_snapshot {"hash":"07b8151b2dc93ae6959754d09c6f3c2428fc7cce","type":"REF_CONSTRAINT","name":"DEPT_MGR_FK","schemaName":"MAXPRINT_DEV","sxml":""}