comment on table maxprint_dev.countries is
    'country table. Contains 25 rows. References with locations table.';

comment on column maxprint_dev.countries.country_id is
    'Primary key of countries table.';

comment on column maxprint_dev.countries.country_name is
    'Country name';

comment on column maxprint_dev.countries.region_id is
    'Region ID for the country. Foreign key to region_id column in the departments table.';


-- sqlcl_snapshot {"hash":"b0bfff668be504e4ce761eb39cafe60833af0595","type":"COMMENT","name":"countries","schemaName":"maxprint_dev","sxml":""}