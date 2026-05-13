alter table maxprint_dev.emp
    add
        foreign key ( deptno )
            references maxprint_dev.dept ( deptno )
        enable;


-- sqlcl_snapshot {"hash":"cc91ee970f063ddbaa01233f6597d703c161dd4d","type":"REF_CONSTRAINT","name":"EMP.MAXPRINT_DEV.DEPT","schemaName":"MAXPRINT_DEV","sxml":""}