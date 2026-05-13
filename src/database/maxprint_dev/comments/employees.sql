comment on table maxprint_dev.employees is
    'employees table. Contains 107 rows. References with departments,
jobs, job_history tables. Contains a self reference.';

comment on column maxprint_dev.employees.commission_pct is
    'Commission percentage of the employee; Only employees in sales
department elgible for commission percentage';

comment on column maxprint_dev.employees.department_id is
    'Department id where employee works; foreign key to department_id
column of the departments table';

comment on column maxprint_dev.employees.email is
    'Email id of the employee';

comment on column maxprint_dev.employees.employee_id is
    'Primary key of employees table.';

comment on column maxprint_dev.employees.first_name is
    'First name of the employee. A not null column.';

comment on column maxprint_dev.employees.hire_date is
    'Date when the employee started on this job. A not null column.';

comment on column maxprint_dev.employees.job_id is
    'Current job of the employee; foreign key to job_id column of the
jobs table. A not null column.';

comment on column maxprint_dev.employees.last_name is
    'Last name of the employee. A not null column.';

comment on column maxprint_dev.employees.manager_id is
    'Manager id of the employee; has same domain as manager_id in
departments table. Foreign key to employee_id column of employees table.
(useful for reflexive joins and CONNECT BY query)';

comment on column maxprint_dev.employees.phone_number is
    'Phone number of the employee; includes country code and area code';

comment on column maxprint_dev.employees.salary is
    'Monthly salary of the employee. Must be greater
than zero (enforced by constraint emp_salary_min)';


-- sqlcl_snapshot {"hash":"b94ff7aed4a3bff29d1f4b6f4cc25811670043ad","type":"COMMENT","name":"employees","schemaName":"maxprint_dev","sxml":""}