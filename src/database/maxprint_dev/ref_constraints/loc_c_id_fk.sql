alter table maxprint_dev.locations
    add constraint loc_c_id_fk
        foreign key ( country_id )
            references maxprint_dev.countries ( country_id )
        enable;


-- sqlcl_snapshot {"hash":"481ecb1acc9b18595950424774a5218350f0dbdb","type":"REF_CONSTRAINT","name":"LOC_C_ID_FK","schemaName":"MAXPRINT_DEV","sxml":""}