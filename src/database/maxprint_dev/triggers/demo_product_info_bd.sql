create or replace editionable trigger maxprint_dev.demo_product_info_bd before
    delete on maxprint_dev.demo_product_info
    for each row
begin
    sample_pkg.demo_tag_sync(
        p_new_tags     => null,
        p_old_tags     => :old.tags,
        p_content_type => 'PRODUCT',
        p_content_id   => :old.product_id
    );
end;
/

alter trigger maxprint_dev.demo_product_info_bd enable;


-- sqlcl_snapshot {"hash":"bcd6d0486a4001d457f91ed40de054732ba70286","type":"TRIGGER","name":"DEMO_PRODUCT_INFO_BD","schemaName":"MAXPRINT_DEV","sxml":""}