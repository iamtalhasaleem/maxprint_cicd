create index maxprint_dev.demo_cust_name_ix on
    maxprint_dev.demo_customers (
        cust_last_name,
        cust_first_name
    );


-- sqlcl_snapshot {"hash":"b5bdf8865d29e46606eff81ac784a78717e56b4a","type":"INDEX","name":"DEMO_CUST_NAME_IX","schemaName":"MAXPRINT_DEV","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>MAXPRINT_DEV</SCHEMA>\n   <NAME>DEMO_CUST_NAME_IX</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>MAXPRINT_DEV</SCHEMA>\n         <NAME>DEMO_CUSTOMERS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>CUST_LAST_NAME</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>CUST_FIRST_NAME</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}