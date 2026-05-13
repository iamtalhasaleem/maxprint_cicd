create table maxprint_dev.job_history (
    employee_id   number(6, 0)
        constraint jhist_employee_nn not null enable,
    start_date    date
        constraint jhist_start_date_nn not null enable,
    end_date      date
        constraint jhist_end_date_nn not null enable,
    job_id        varchar2(10 byte)
        constraint jhist_job_nn not null enable,
    department_id number(4, 0)
);

create unique index maxprint_dev.jhist_emp_id_st_date_pk on
    maxprint_dev.job_history (
        employee_id,
        start_date
    );

alter table maxprint_dev.job_history add constraint jhist_date_interval check ( end_date > start_date ) enable;

alter table maxprint_dev.job_history
    add constraint jhist_emp_id_st_date_pk
        primary key ( employee_id,
                      start_date )
            using index maxprint_dev.jhist_emp_id_st_date_pk enable;


-- sqlcl_snapshot {"hash":"e5988f12f7ff881f14ea1c2b8d715800441b77d8","type":"TABLE","name":"JOB_HISTORY","schemaName":"MAXPRINT_DEV","sxml":"\n  <TABLE xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>MAXPRINT_DEV</SCHEMA>\n   <NAME>JOB_HISTORY</NAME>\n   <RELATIONAL_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>EMPLOYEE_ID</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <PRECISION>6</PRECISION>\n            <SCALE>0</SCALE>\n            <NOT_NULL>\n               <NAME>JHIST_EMPLOYEE_NN</NAME>\n            </NOT_NULL>\n            \n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>START_DATE</NAME>\n            <DATATYPE>DATE</DATATYPE>\n            <NOT_NULL>\n               <NAME>JHIST_START_DATE_NN</NAME>\n            </NOT_NULL>\n            \n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>END_DATE</NAME>\n            <DATATYPE>DATE</DATATYPE>\n            <NOT_NULL>\n               <NAME>JHIST_END_DATE_NN</NAME>\n            </NOT_NULL>\n            \n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>JOB_ID</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>10</LENGTH>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <NOT_NULL>\n               <NAME>JHIST_JOB_NN</NAME>\n            </NOT_NULL>\n            \n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>DEPARTMENT_ID</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <PRECISION>4</PRECISION>\n            <SCALE>0</SCALE>\n            \n         </COL_LIST_ITEM>\n      </COL_LIST>\n      <CHECK_CONSTRAINT_LIST>\n         <CHECK_CONSTRAINT_LIST_ITEM>\n            <NAME>JHIST_DATE_INTERVAL</NAME>\n            <CONDITION>end_date > start_date</CONDITION>\n         </CHECK_CONSTRAINT_LIST_ITEM>\n      </CHECK_CONSTRAINT_LIST>\n      <PRIMARY_KEY_CONSTRAINT_LIST>\n         <PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n            <NAME>JHIST_EMP_ID_ST_DATE_PK</NAME>\n            <COL_LIST>\n               <COL_LIST_ITEM>\n                  <NAME>EMPLOYEE_ID</NAME>\n               </COL_LIST_ITEM>\n               <COL_LIST_ITEM>\n                  <NAME>START_DATE</NAME>\n               </COL_LIST_ITEM>\n            </COL_LIST>\n            <USING_INDEX></USING_INDEX>\n         </PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n      </PRIMARY_KEY_CONSTRAINT_LIST>\n      <DEFAULT_COLLATION>USING_NLS_COMP</DEFAULT_COLLATION>\n      <PHYSICAL_PROPERTIES>\n         <HEAP_TABLE></HEAP_TABLE>\n      </PHYSICAL_PROPERTIES>\n      \n   </RELATIONAL_TABLE>\n</TABLE>"}