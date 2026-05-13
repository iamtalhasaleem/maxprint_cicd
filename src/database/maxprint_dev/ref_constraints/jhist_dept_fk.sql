alter table maxprint_dev.job_history
    add constraint jhist_dept_fk
        foreign key ( department_id )
            references maxprint_dev.departments ( department_id )
        enable;


-- sqlcl_snapshot {"hash":"d2e954b7a8b88c25095f4f94658abcc795117b38","type":"REF_CONSTRAINT","name":"JHIST_DEPT_FK","schemaName":"MAXPRINT_DEV","sxml":""}