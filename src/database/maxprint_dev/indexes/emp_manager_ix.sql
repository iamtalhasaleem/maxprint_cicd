create index maxprint_dev.emp_manager_ix on
    maxprint_dev.employees (
        manager_id
    );


-- sqlcl_snapshot {"hash":"b815e272e76ea80ed44f3ab6a8751496a29ef061","type":"INDEX","name":"EMP_MANAGER_IX","schemaName":"MAXPRINT_DEV","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>MAXPRINT_DEV</SCHEMA>\n   <NAME>EMP_MANAGER_IX</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>MAXPRINT_DEV</SCHEMA>\n         <NAME>EMPLOYEES</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>MANAGER_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}