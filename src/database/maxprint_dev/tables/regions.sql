create table maxprint_dev.regions (
    region_id   number
        constraint region_id_nn not null enable,
    region_name varchar2(25 byte)
);

create unique index maxprint_dev.reg_id_pk on
    maxprint_dev.regions (
        region_id
    );

alter table maxprint_dev.regions
    add constraint reg_id_pk
        primary key ( region_id )
            using index maxprint_dev.reg_id_pk enable;


-- sqlcl_snapshot {"hash":"38879302839b07f7228d7c0caa16be7647fdb30b","type":"TABLE","name":"REGIONS","schemaName":"MAXPRINT_DEV","sxml":"\n  <TABLE xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>MAXPRINT_DEV</SCHEMA>\n   <NAME>REGIONS</NAME>\n   <RELATIONAL_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>REGION_ID</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <NOT_NULL>\n               <NAME>REGION_ID_NN</NAME>\n            </NOT_NULL>\n            \n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>REGION_NAME</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>25</LENGTH>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            \n         </COL_LIST_ITEM>\n      </COL_LIST>\n      <PRIMARY_KEY_CONSTRAINT_LIST>\n         <PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n            <NAME>REG_ID_PK</NAME>\n            <COL_LIST>\n               <COL_LIST_ITEM>\n                  <NAME>REGION_ID</NAME>\n               </COL_LIST_ITEM>\n            </COL_LIST>\n            <USING_INDEX></USING_INDEX>\n         </PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n      </PRIMARY_KEY_CONSTRAINT_LIST>\n      <DEFAULT_COLLATION>USING_NLS_COMP</DEFAULT_COLLATION>\n      <PHYSICAL_PROPERTIES>\n         <HEAP_TABLE></HEAP_TABLE>\n      </PHYSICAL_PROPERTIES>\n      \n   </RELATIONAL_TABLE>\n</TABLE>"}