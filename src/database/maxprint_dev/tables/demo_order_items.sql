create table maxprint_dev.demo_order_items (
    order_item_id number(3, 0) not null enable,
    order_id      number not null enable,
    product_id    number not null enable,
    unit_price    number(8, 2) not null enable,
    quantity      number(8, 0) not null enable
);

alter table maxprint_dev.demo_order_items
    add constraint demo_order_items_pk primary key ( order_item_id )
        using index enable;

alter table maxprint_dev.demo_order_items
    add constraint demo_order_items_uk unique ( order_id,
                                                product_id )
        using index enable;


-- sqlcl_snapshot {"hash":"d5fb5f3e7a0ff767ff127d50c29c75e6f9612f6c","type":"TABLE","name":"DEMO_ORDER_ITEMS","schemaName":"MAXPRINT_DEV","sxml":"\n  <TABLE xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>MAXPRINT_DEV</SCHEMA>\n   <NAME>DEMO_ORDER_ITEMS</NAME>\n   <RELATIONAL_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ORDER_ITEM_ID</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <PRECISION>3</PRECISION>\n            <SCALE>0</SCALE>\n            <NOT_NULL></NOT_NULL>\n            \n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ORDER_ID</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <NOT_NULL></NOT_NULL>\n            \n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>PRODUCT_ID</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <NOT_NULL></NOT_NULL>\n            \n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>UNIT_PRICE</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <PRECISION>8</PRECISION>\n            <SCALE>2</SCALE>\n            <NOT_NULL></NOT_NULL>\n            \n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>QUANTITY</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <PRECISION>8</PRECISION>\n            <SCALE>0</SCALE>\n            <NOT_NULL></NOT_NULL>\n            \n         </COL_LIST_ITEM>\n      </COL_LIST>\n      <PRIMARY_KEY_CONSTRAINT_LIST>\n         <PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n            <NAME>DEMO_ORDER_ITEMS_PK</NAME>\n            <COL_LIST>\n               <COL_LIST_ITEM>\n                  <NAME>ORDER_ITEM_ID</NAME>\n               </COL_LIST_ITEM>\n            </COL_LIST>\n            <USING_INDEX></USING_INDEX>\n         </PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n      </PRIMARY_KEY_CONSTRAINT_LIST>\n      <UNIQUE_KEY_CONSTRAINT_LIST>\n         <UNIQUE_KEY_CONSTRAINT_LIST_ITEM>\n            <NAME>DEMO_ORDER_ITEMS_UK</NAME>\n            <COL_LIST>\n               <COL_LIST_ITEM>\n                  <NAME>ORDER_ID</NAME>\n               </COL_LIST_ITEM>\n               <COL_LIST_ITEM>\n                  <NAME>PRODUCT_ID</NAME>\n               </COL_LIST_ITEM>\n            </COL_LIST>\n            <USING_INDEX></USING_INDEX>\n         </UNIQUE_KEY_CONSTRAINT_LIST_ITEM>\n      </UNIQUE_KEY_CONSTRAINT_LIST>\n      <DEFAULT_COLLATION>USING_NLS_COMP</DEFAULT_COLLATION>\n      <PHYSICAL_PROPERTIES>\n         <HEAP_TABLE></HEAP_TABLE>\n      </PHYSICAL_PROPERTIES>\n      \n   </RELATIONAL_TABLE>\n</TABLE>"}