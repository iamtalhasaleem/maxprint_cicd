alter table maxprint_dev.departments
    add constraint dept_loc_fk
        foreign key ( location_id )
            references maxprint_dev.locations ( location_id )
        enable;


-- sqlcl_snapshot {"hash":"cf66fd5f37989edc4de52c6485dc3982a556dbb9","type":"REF_CONSTRAINT","name":"DEPT_LOC_FK","schemaName":"MAXPRINT_DEV","sxml":""}