create or replace editionable trigger maxprint_dev.demo_order_items_bi before
    insert on maxprint_dev.demo_order_items
    for each row
declare
    order_item_id number;
begin
    if :new.order_item_id is null then
        select
            demo_order_items_seq.nextval
        into order_item_id
        from
            dual;

        :new.order_item_id := order_item_id;
    end if;
end;
/

alter trigger maxprint_dev.demo_order_items_bi enable;


-- sqlcl_snapshot {"hash":"2b6f096399f33856e2d911520feb3ed858bcb679","type":"TRIGGER","name":"DEMO_ORDER_ITEMS_BI","schemaName":"MAXPRINT_DEV","sxml":""}