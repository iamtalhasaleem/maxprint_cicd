create table maxprint_dev.countries (
    country_id   char(2 byte)
        constraint country_id_nn not null enable,
    country_name varchar2(40 byte),
    region_id    number,
    constraint country_c_id_pk primary key ( country_id ) enable
)
organization index nocompress;


-- sqlcl_snapshot {"hash":"c36dff0fc4dfcbe7ff981534ad9710a1d5eaab2f","type":"TABLE","name":"COUNTRIES","schemaName":"MAXPRINT_DEV","sxml":"\n  <TABLE xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>MAXPRINT_DEV</SCHEMA>\n   <NAME>COUNTRIES</NAME>\n   <RELATIONAL_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>COUNTRY_ID</NAME>\n            <DATATYPE>CHAR</DATATYPE>\n            <LENGTH>2</LENGTH>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <NOT_NULL>\n               <NAME>COUNTRY_ID_NN</NAME>\n            </NOT_NULL>\n            \n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>COUNTRY_NAME</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>40</LENGTH>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            \n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>REGION_ID</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            \n         </COL_LIST_ITEM>\n      </COL_LIST>\n      <PRIMARY_KEY_CONSTRAINT_LIST>\n         <PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n            <NAME>COUNTRY_C_ID_PK</NAME>\n            <COL_LIST>\n               <COL_LIST_ITEM>\n                  <NAME>COUNTRY_ID</NAME>\n               </COL_LIST_ITEM>\n            </COL_LIST>\n         </PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n      </PRIMARY_KEY_CONSTRAINT_LIST>\n      <DEFAULT_COLLATION>USING_NLS_COMP</DEFAULT_COLLATION>\n      <PHYSICAL_PROPERTIES>\n         <INDEX_ORGANIZED_TABLE>\n            <PCTTHRESHOLD>50</PCTTHRESHOLD>\n         </INDEX_ORGANIZED_TABLE>\n      </PHYSICAL_PROPERTIES>\n      \n   </RELATIONAL_TABLE>\n</TABLE>"}