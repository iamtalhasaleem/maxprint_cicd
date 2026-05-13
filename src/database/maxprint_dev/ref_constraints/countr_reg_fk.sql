alter table maxprint_dev.countries
    add constraint countr_reg_fk
        foreign key ( region_id )
            references maxprint_dev.regions ( region_id )
        enable;


-- sqlcl_snapshot {"hash":"3ef3de787c6a6f7aaad7d9252ac83c0e435b9abf","type":"REF_CONSTRAINT","name":"COUNTR_REG_FK","schemaName":"MAXPRINT_DEV","sxml":""}