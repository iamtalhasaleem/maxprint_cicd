alter table maxprint_dev.demo_order_items
    add constraint demo_order_items_product_id_fk
        foreign key ( product_id )
            references maxprint_dev.demo_product_info ( product_id )
                on delete cascade
        enable;


-- sqlcl_snapshot {"hash":"6f58b3faf84b59364c1c9b327553dc1f8acc0dc9","type":"REF_CONSTRAINT","name":"DEMO_ORDER_ITEMS_PRODUCT_ID_FK","schemaName":"MAXPRINT_DEV","sxml":""}