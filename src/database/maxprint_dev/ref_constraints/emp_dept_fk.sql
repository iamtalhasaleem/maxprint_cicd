alter table maxprint_dev.employees
    add constraint emp_dept_fk
        foreign key ( department_id )
            references maxprint_dev.departments ( department_id )
        enable;


-- sqlcl_snapshot {"hash":"24df90c2937ae7d430adb3c8f7814440eab502dc","type":"REF_CONSTRAINT","name":"EMP_DEPT_FK","schemaName":"MAXPRINT_DEV","sxml":""}