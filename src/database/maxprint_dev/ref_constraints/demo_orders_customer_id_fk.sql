alter table maxprint_dev.demo_orders
    add constraint demo_orders_customer_id_fk
        foreign key ( customer_id )
            references maxprint_dev.demo_customers ( customer_id )
                on delete cascade
        enable;


-- sqlcl_snapshot {"hash":"9d5daa1a91a99f3f8c705bc74bbdb5a38c5183bd","type":"REF_CONSTRAINT","name":"DEMO_ORDERS_CUSTOMER_ID_FK","schemaName":"MAXPRINT_DEV","sxml":""}