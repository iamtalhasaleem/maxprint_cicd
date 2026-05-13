alter table maxprint_dev.emp
    add
        foreign key ( mgr )
            references maxprint_dev.emp ( empno )
        enable;


-- sqlcl_snapshot {"hash":"14874b5d2d17fda94ffe3d912d3ae2800280931f","type":"REF_CONSTRAINT","name":"EMP.MAXPRINT_DEV.EMP","schemaName":"MAXPRINT_DEV","sxml":""}