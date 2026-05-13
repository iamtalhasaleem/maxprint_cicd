alter table maxprint_dev.demo_order_items
    add constraint demo_order_items_fk
        foreign key ( order_id )
            references maxprint_dev.demo_orders ( order_id )
                on delete cascade
        enable;


-- sqlcl_snapshot {"hash":"c8871394e07cfbb250c0a5dd4c7bb211986428da","type":"REF_CONSTRAINT","name":"DEMO_ORDER_ITEMS_FK","schemaName":"MAXPRINT_DEV","sxml":""}