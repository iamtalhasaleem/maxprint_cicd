create index maxprint_dev.demo_ord_customer_ix on
    maxprint_dev.demo_orders (
        customer_id
    );


-- sqlcl_snapshot {"hash":"ded8b1c3d8b752978fe8dc6167afb04891ebec8d","type":"INDEX","name":"DEMO_ORD_CUSTOMER_IX","schemaName":"MAXPRINT_DEV","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>MAXPRINT_DEV</SCHEMA>\n   <NAME>DEMO_ORD_CUSTOMER_IX</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>MAXPRINT_DEV</SCHEMA>\n         <NAME>DEMO_ORDERS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>CUSTOMER_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}