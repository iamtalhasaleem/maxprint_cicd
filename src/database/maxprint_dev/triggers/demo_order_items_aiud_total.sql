create or replace editionable trigger maxprint_dev.demo_order_items_aiud_total after
    insert or update or delete on maxprint_dev.demo_order_items
begin
  -- Update the Order Total when any order item is changed
    update demo_orders
    set
        order_total = (
            select
                sum(unit_price * quantity)
            from
                demo_order_items
            where
                demo_order_items.order_id = demo_orders.order_id
        );

end;
/

alter trigger maxprint_dev.demo_order_items_aiud_total enable;


-- sqlcl_snapshot {"hash":"a1375859bc310f1ddbe05093538fe4bed2eb2e0f","type":"TRIGGER","name":"DEMO_ORDER_ITEMS_AIUD_TOTAL","schemaName":"MAXPRINT_DEV","sxml":""}