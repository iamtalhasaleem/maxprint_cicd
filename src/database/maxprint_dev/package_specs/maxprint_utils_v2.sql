create or replace package maxprint_dev.maxprint_utils_v2 as
    function get_files_from_url (
        p_url              in varchar2,
        p_http_method      in varchar2 default 'GET',
        p_username         in varchar2 default null,
        p_password         in varchar2 default null,
        p_proxy_override   in varchar2 default null,
        p_transfer_timeout in number default 180,
        p_wallet_path      in varchar2 default null,
        p_wallet_password  in varchar2 default null
    ) return clob;

    function maxprint_call (
        p_dynamic_action in apex_plugin.t_dynamic_action,
        p_plugin         in apex_plugin.t_plugin
    ) return apex_plugin.t_dynamic_action_render_result;

    function maxprint_da_ajax (
        p_dynamic_action in apex_plugin.t_dynamic_action,
        p_plugin         in apex_plugin.t_plugin
    ) return apex_plugin.t_dynamic_action_ajax_result;

end maxprint_utils_v2;
/


-- sqlcl_snapshot {"hash":"a569f23f005ebf25bd2d4741002d06986284db9d","type":"PACKAGE_SPEC","name":"MAXPRINT_UTILS_V2","schemaName":"MAXPRINT_DEV","sxml":""}