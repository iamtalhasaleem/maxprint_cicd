create or replace editionable trigger maxprint_dev.demo_tags_biu before
    insert or update on maxprint_dev.demo_tags
    for each row
begin
    if inserting then
        if :new.id is null then
            select
                to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX')
            into :new.id
            from
                dual;

        end if;

        :new.created := localtimestamp;
        :new.created_by := nvl(
            v('APP_USER'),
            user
        );
    end if;

    if updating then
        :new.updated := localtimestamp;
        :new.updated_by := nvl(
            v('APP_USER'),
            user
        );
    end if;

end;
/

alter trigger maxprint_dev.demo_tags_biu enable;


-- sqlcl_snapshot {"hash":"fc4f781a0cd1c0e49a7d29b338a7e5343da76e66","type":"TRIGGER","name":"DEMO_TAGS_BIU","schemaName":"MAXPRINT_DEV","sxml":""}