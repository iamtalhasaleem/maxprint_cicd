create or replace editionable trigger maxprint_dev.demo_orders_biu before
    insert or update on maxprint_dev.demo_orders
    for each row
declare
    order_id number;
begin
    if inserting then
        if :new.order_id is null then
            select
                demo_ord_seq.nextval
            into order_id
            from
                dual;

            :new.order_id := order_id;
        end if;

        if :new.tags is not null then
            :new.tags := sample_pkg.demo_tags_cleaner(:new.tags);
        end if;

    end if;

    sample_pkg.demo_tag_sync(
        p_new_tags     => :new.tags,
        p_old_tags     => :old.tags,
        p_content_type => 'ORDER',
        p_content_id   => :new.order_id
    );

end;
/

alter trigger maxprint_dev.demo_orders_biu enable;


-- sqlcl_snapshot {"hash":"4152662019c21781131198fbcb5cfc471d62cef4","type":"TRIGGER","name":"DEMO_ORDERS_BIU","schemaName":"MAXPRINT_DEV","sxml":""}