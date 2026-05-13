alter table maxprint_dev.job_history
    add constraint jhist_job_fk
        foreign key ( job_id )
            references maxprint_dev.jobs ( job_id )
        enable;


-- sqlcl_snapshot {"hash":"b08a1c40ce44fb4376ab783d6639f36cc90f520f","type":"REF_CONSTRAINT","name":"JHIST_JOB_FK","schemaName":"MAXPRINT_DEV","sxml":""}