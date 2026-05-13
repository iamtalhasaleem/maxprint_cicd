create or replace editionable trigger maxprint_dev.demo_customers_biu before
    insert or update on maxprint_dev.demo_customers
    for each row
declare
    cust_id number;
begin
    if inserting then
        if :new.customer_id is null then
            select
                demo_cust_seq.nextval
            into cust_id
            from
                dual;

            :new.customer_id := cust_id;
        end if;

        if :new.tags is not null then
            :new.tags := sample_pkg.demo_tags_cleaner(:new.tags);
        end if;

    end if;

    sample_pkg.demo_tag_sync(
        p_new_tags     => :new.tags,
        p_old_tags     => :old.tags,
        p_content_type => 'CUSTOMER',
        p_content_id   => :new.customer_id
    );

end;
/

alter trigger maxprint_dev.demo_customers_biu enable;


-- sqlcl_snapshot {"hash":"878d77d02e036a6073a1acaefe389e8414c265d7","type":"TRIGGER","name":"DEMO_CUSTOMERS_BIU","schemaName":"MAXPRINT_DEV","sxml":""}