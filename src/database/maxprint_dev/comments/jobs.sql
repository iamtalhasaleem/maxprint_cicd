comment on table maxprint_dev.jobs is
    'jobs table with job titles and salary ranges. Contains 19 rows.
References with employees and job_history table.';

comment on column maxprint_dev.jobs.job_id is
    'Primary key of jobs table.';

comment on column maxprint_dev.jobs.job_title is
    'A not null column that shows job title, e.g. AD_VP, FI_ACCOUNTANT';

comment on column maxprint_dev.jobs.max_salary is
    'Maximum salary for a job title';

comment on column maxprint_dev.jobs.min_salary is
    'Minimum salary for a job title.';


-- sqlcl_snapshot {"hash":"b332de2d2a65c0c6be410976c26689b7accf92a5","type":"COMMENT","name":"jobs","schemaName":"maxprint_dev","sxml":""}