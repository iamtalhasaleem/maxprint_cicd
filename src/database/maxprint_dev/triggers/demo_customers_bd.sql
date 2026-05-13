create or replace editionable trigger maxprint_dev.demo_customers_bd before
    delete on maxprint_dev.demo_customers
    for each row
begin
    sample_pkg.demo_tag_sync(
        p_new_tags     => null,
        p_old_tags     => :old.tags,
        p_content_type => 'CUSTOMER',
        p_content_id   => :old.customer_id
    );
end;
/

alter trigger maxprint_dev.demo_customers_bd enable;


-- sqlcl_snapshot {"hash":"613c9940bafabcdea92b3649c9cb758bf2be0fb5","type":"TRIGGER","name":"DEMO_CUSTOMERS_BD","schemaName":"MAXPRINT_DEV","sxml":""}