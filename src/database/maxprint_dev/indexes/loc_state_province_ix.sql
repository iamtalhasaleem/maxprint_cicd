create index maxprint_dev.loc_state_province_ix on
    maxprint_dev.locations (
        state_province
    );


-- sqlcl_snapshot {"hash":"d44ab0d4d36309ef0c9a6b549c0ebbdf853e45d4","type":"INDEX","name":"LOC_STATE_PROVINCE_IX","schemaName":"MAXPRINT_DEV","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>MAXPRINT_DEV</SCHEMA>\n   <NAME>LOC_STATE_PROVINCE_IX</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>MAXPRINT_DEV</SCHEMA>\n         <NAME>LOCATIONS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>STATE_PROVINCE</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}