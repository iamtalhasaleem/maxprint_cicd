comment on table maxprint_dev.locations is
    'Locations table that contains specific address of a specific office,
warehouse, and/or production site of a company. Does not store addresses /
locations of customers. Contains 23 rows; references with the
departments and countries tables. ';

comment on column maxprint_dev.locations.city is
    'A not null column that shows city where an office, warehouse, or
production site of a company is located. ';

comment on column maxprint_dev.locations.country_id is
    'Country where an office, warehouse, or production site of a company is
located. Foreign key to country_id column of the countries table.';

comment on column maxprint_dev.locations.location_id is
    'Primary key of locations table';

comment on column maxprint_dev.locations.postal_code is
    'Postal code of the location of an office, warehouse, or production site
of a company. ';

comment on column maxprint_dev.locations.state_province is
    'State or Province where an office, warehouse, or production site of a
company is located.';

comment on column maxprint_dev.locations.street_address is
    'Street address of an office, warehouse, or production site of a company.
Contains building number and street name';


-- sqlcl_snapshot {"hash":"06d9131e3e5c95e89556a803c13c45529e98ee45","type":"COMMENT","name":"locations","schemaName":"maxprint_dev","sxml":""}