create or replace editionable trigger maxprint_dev.demo_orders_bd before
    delete on maxprint_dev.demo_orders
    for each row
begin
    sample_pkg.demo_tag_sync(
        p_new_tags     => null,
        p_old_tags     => :old.tags,
        p_content_type => 'ORDER',
        p_content_id   => :old.order_id
    );
end;
/

alter trigger maxprint_dev.demo_orders_bd enable;


-- sqlcl_snapshot {"hash":"08067bdb58742a7dcde3dbd2429722823f595d59","type":"TRIGGER","name":"DEMO_ORDERS_BD","schemaName":"MAXPRINT_DEV","sxml":""}