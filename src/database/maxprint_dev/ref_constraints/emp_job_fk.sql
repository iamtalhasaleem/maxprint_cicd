alter table maxprint_dev.employees
    add constraint emp_job_fk
        foreign key ( job_id )
            references maxprint_dev.jobs ( job_id )
        enable;


-- sqlcl_snapshot {"hash":"cf2fa4a67cecb256e84492e68fe8eac922dab178","type":"REF_CONSTRAINT","name":"EMP_JOB_FK","schemaName":"MAXPRINT_DEV","sxml":""}