create or replace package maxprint_dev.maxprint_plsql_api_v2 as
    v_url varchar2(100) := 'https://appv2.maxprint.io/api/v1';
    v_report_context varchar2(100) := '/report/run/template/';
    v_app_id varchar2(50) := v('APP_ID');
    v_workspace_id varchar2(50) := v('WORKSPACE_ID');
    v_timeout number := 6000;
    v_debug boolean := false;
    v_development_mode boolean := false;
    function maxprint_api_call (
        p_url              in varchar2,
        p_api_key          in varchar2,
        p_data             in clob,
        p_output_type      in varchar2,
        p_template         in clob default null,
        p_template_id      in varchar2 default null,
        p_wallet_path      in varchar2 default null,
        p_wallet_password  in varchar2 default null,
        p_timeout          in number default v_timeout,
        p_debug            in boolean default v_debug,
        p_development_mode in boolean default v_development_mode
    ) return clob;

    procedure print_payload (
        p_text in out nocopy clob
    );

    procedure dbms_print_payload (
        p_text in out nocopy clob
    );

    function get_apex_directory_content_json (
        p_directory in varchar2,
        p_file_name in varchar2,
        p_app       in varchar2 default v_app_id,
        p_workspace in varchar2 default v_workspace_id
    ) return clob;

    function get_json_from_plsql (
        pl_code          in clob,
        p_datasoure_type varchar2 default 'FRS'
    ) return clob;

    function get_json_from_sql (
        p_sql               in clob,
        p_sql_type          varchar2,
        p_query_master_cols varchar2 default null
    ) return clob;

    function get_json_from_refcursor (
        p_refcursor in sys_refcursor
    ) return clob;

    function maxprint_generate_report_clob (
        p_api_key          in varchar2,
        p_data             in clob,
        p_output_type      in varchar2,
        p_template         in clob default null,
        p_template_id      in varchar2 default null,
        p_wallet_path      in varchar2 default null,
        p_wallet_password  in varchar2 default null,
        p_timeout          in number default v_timeout,
        p_url              in varchar2 default v_url || v_report_context,
        p_debug            in boolean default v_debug,
        p_development_mode in boolean default v_development_mode
    ) return clob;

    function maxprint_generate_report_blob (
        p_api_key          in varchar2,
        p_data             in clob,
        p_output_type      in varchar2,
        p_template         in clob default null,
        p_template_id      in varchar2 default null,
        p_wallet_path      in varchar2 default null,
        p_wallet_password  in varchar2 default null,
        p_timeout          in number default v_timeout,
        p_url              in varchar2 default v_url || v_report_context,
        p_debug            in boolean default v_debug,
        p_development_mode in boolean default v_development_mode
    ) return blob;

end maxprint_plsql_api_v2;
/


-- sqlcl_snapshot {"hash":"037c228fff47f4fcdb8f3551642f821eeaa2f62e","type":"PACKAGE_SPEC","name":"MAXPRINT_PLSQL_API_V2","schemaName":"MAXPRINT_DEV","sxml":""}