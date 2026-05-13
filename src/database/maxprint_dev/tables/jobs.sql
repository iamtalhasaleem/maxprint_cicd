create table maxprint_dev.jobs (
    job_id     varchar2(10 byte),
    job_title  varchar2(35 byte)
        constraint job_title_nn not null enable,
    min_salary number(6, 0),
    max_salary number(6, 0)
);

create unique index maxprint_dev.job_id_pk on
    maxprint_dev.jobs (
        job_id
    );

alter table maxprint_dev.jobs
    add constraint job_id_pk
        primary key ( job_id )
            using index maxprint_dev.job_id_pk enable;


-- sqlcl_snapshot {"hash":"a7cadbfa40217fcb08a42b54511db7dbdefbddb1","type":"TABLE","name":"JOBS","schemaName":"MAXPRINT_DEV","sxml":"\n  <TABLE xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>MAXPRINT_DEV</SCHEMA>\n   <NAME>JOBS</NAME>\n   <RELATIONAL_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>JOB_ID</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>10</LENGTH>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            \n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>JOB_TITLE</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>35</LENGTH>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <NOT_NULL>\n               <NAME>JOB_TITLE_NN</NAME>\n            </NOT_NULL>\n            \n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>MIN_SALARY</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <PRECISION>6</PRECISION>\n            <SCALE>0</SCALE>\n            \n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>MAX_SALARY</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <PRECISION>6</PRECISION>\n            <SCALE>0</SCALE>\n            \n         </COL_LIST_ITEM>\n      </COL_LIST>\n      <PRIMARY_KEY_CONSTRAINT_LIST>\n         <PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n            <NAME>JOB_ID_PK</NAME>\n            <COL_LIST>\n               <COL_LIST_ITEM>\n                  <NAME>JOB_ID</NAME>\n               </COL_LIST_ITEM>\n            </COL_LIST>\n            <USING_INDEX></USING_INDEX>\n         </PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n      </PRIMARY_KEY_CONSTRAINT_LIST>\n      <DEFAULT_COLLATION>USING_NLS_COMP</DEFAULT_COLLATION>\n      <PHYSICAL_PROPERTIES>\n         <HEAP_TABLE></HEAP_TABLE>\n      </PHYSICAL_PROPERTIES>\n      \n   </RELATIONAL_TABLE>\n</TABLE>"}