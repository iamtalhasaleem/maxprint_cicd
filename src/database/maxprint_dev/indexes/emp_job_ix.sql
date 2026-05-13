create index maxprint_dev.emp_job_ix on
    maxprint_dev.employees (
        job_id
    );


-- sqlcl_snapshot {"hash":"f24e68a9c6612fe7e529ed16db92469fe7590088","type":"INDEX","name":"EMP_JOB_IX","schemaName":"MAXPRINT_DEV","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>MAXPRINT_DEV</SCHEMA>\n   <NAME>EMP_JOB_IX</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>MAXPRINT_DEV</SCHEMA>\n         <NAME>EMPLOYEES</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>JOB_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}