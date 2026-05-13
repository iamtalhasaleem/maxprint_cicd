create or replace editionable trigger maxprint_dev.demo_order_items_biu_get_price before
    insert or update on maxprint_dev.demo_order_items
    for each row
declare
    l_list_price number;
begin
    if :new.unit_price is null then
    -- First, we need to get the current list price of the order line item
        select
            list_price
        into l_list_price
        from
            demo_product_info
        where
            product_id = :new.product_id;
    -- Once we have the correct price, we will update the order line with the correct price
        :new.unit_price := l_list_price;
    end if;
end;
/

alter trigger maxprint_dev.demo_order_items_biu_get_price enable;


-- sqlcl_snapshot {"hash":"7697ccdbfa969f915af5e6c1e349e42068c6e12a","type":"TRIGGER","name":"DEMO_ORDER_ITEMS_BIU_GET_PRICE","schemaName":"MAXPRINT_DEV","sxml":""}