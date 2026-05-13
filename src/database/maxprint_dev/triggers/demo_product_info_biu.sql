create or replace editionable trigger maxprint_dev.demo_product_info_biu before
    insert or update on maxprint_dev.demo_product_info
    for each row
declare
    prod_id number;
begin
    if inserting then
        if :new.product_id is null then
            select
                demo_prod_seq.nextval
            into prod_id
            from
                dual;

            :new.product_id := prod_id;
        end if;

        if :new.tags is not null then
            :new.tags := sample_pkg.demo_tags_cleaner(:new.tags);
        end if;

    end if;

    sample_pkg.demo_tag_sync(
        p_new_tags     => :new.tags,
        p_old_tags     => :old.tags,
        p_content_type => 'PRODUCT',
        p_content_id   => :new.product_id
    );

end;
/

alter trigger maxprint_dev.demo_product_info_biu enable;


-- sqlcl_snapshot {"hash":"2dc9a2374edf7348be5fe70c8ff42689be395957","type":"TRIGGER","name":"DEMO_PRODUCT_INFO_BIU","schemaName":"MAXPRINT_DEV","sxml":""}