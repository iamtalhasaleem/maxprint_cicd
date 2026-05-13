create or replace editionable trigger maxprint_dev.update_job_history after
    update of job_id, department_id on maxprint_dev.employees
    for each row
begin
    add_job_history(:old.employee_id,
                    :old.hire_date,
                    sysdate,
                    :old.job_id,
                    :old.department_id);
end;
/

alter trigger maxprint_dev.update_job_history enable;


-- sqlcl_snapshot {"hash":"4949ba64abc64704c0bb8265630b0e0e89985a9f","type":"TRIGGER","name":"UPDATE_JOB_HISTORY","schemaName":"MAXPRINT_DEV","sxml":""}