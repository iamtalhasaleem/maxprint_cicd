create index maxprint_dev.emp_department_ix on
    maxprint_dev.employees (
        department_id
    );


-- sqlcl_snapshot {"hash":"83bd4ef9045690bfc6d63cb0a9f40c59c64270e6","type":"INDEX","name":"EMP_DEPARTMENT_IX","schemaName":"MAXPRINT_DEV","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>MAXPRINT_DEV</SCHEMA>\n   <NAME>EMP_DEPARTMENT_IX</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>MAXPRINT_DEV</SCHEMA>\n         <NAME>EMPLOYEES</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>DEPARTMENT_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}