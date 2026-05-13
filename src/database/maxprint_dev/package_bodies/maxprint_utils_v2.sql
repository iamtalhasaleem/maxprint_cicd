create or replace package body maxprint_dev.maxprint_utils_v2 as

    appid       varchar2(50) := v('APP_ID');
    workspaceid varchar2(50) := v('WORKSPACE_ID');
    pageid      varchar2(100) := v('APP_PAGE_ID');
    sessionid   varchar2(100) := v('APP_SESSION');
    userid      varchar2(100) := v('APP_USER');

    function generate_response_body (
        p_file_name    in varchar2,
        p_mime_type    in varchar2,
        p_redirect_url in varchar2,
        p_data         in clob
    ) return clob as
        result_data clob;
    begin
        apex_json.open_object;
        apex_json.write('file_name', p_file_name);
        apex_json.write('mime_type', p_mime_type);
        apex_json.write('redirect_url', p_redirect_url);
        apex_json.write('data', p_data);
        apex_json.close_object;
        result_data := apex_json.get_clob_output;
        apex_json.free_output;
        return result_data;
    end;

    function parse_error_code (
        p_err_code in varchar2
    ) return varchar2 as
    begin
        if ( p_err_code = 404 ) then
            return 'Invalid Url';
        elsif
            substr(p_err_code, 0, 1) = 4
            and ( p_err_code not in ( 400, 403, 401 ) )
        then
            return p_err_code || ' Maxprint Client Error';
        elsif substr(p_err_code, 0, 1) = 5 then
            return 'Maxprint Service Unavailable';
        else
            return null;
        end if;
    end;

    function parse_errors (
        p_err_msg in varchar2
    ) return varchar2 as
        l_json     json_object_t;
        l_features json_array_t;
    begin
        apex_json.parse(p_err_msg);
        return apex_json.get_varchar2(p_path => 'error');
    end;

    procedure raise_error (
        p_error_message in varchar2
    ) is
    begin
        raise_application_error(-20010, p_error_message, false);
    end;

    function get_trace_logs return clob as
        v_stack_trace clob;
    begin
        select
            json_object(
                'STACK_TRACE' value json_arrayagg(
                    json_object(
                        'MESSAGE' value message,
                        'LEVEL' value message_level,
                        'EXECUTION_TIME' value execution_time,
                        'ELAPSED_TIME' value elapsed_time,
                        'APPLICATION_ID' value application_id,
                                'PAGE_ID' value page_id
                    returning clob)
                returning clob)
            returning clob)
        into v_stack_trace
        from
            apex_debug_messages
        where
                application_id = appid
            and session_id = sessionid
            and apex_user = userid
            and page_id = pageid
        order by
            execution_time;

        return v_stack_trace;
    exception
        when no_data_found then
            return '{"STACK_TRACE":"No Trace Found"}';
    end;

    procedure debug (
        p_message in varchar2,
        p_level   in number
    ) is
    begin
        if apex_application.g_debug then
            apex_debug_message.log_message(
                p_message => p_message,
                p_level   => p_level
            );
        end if;
    end;

    function return_base64uri (
        p_mime_type in varchar2,
        p_charset   in varchar2 default null
    ) return varchar2 as
    begin
        if p_charset is null then
            return 'data:'
                   || p_mime_type
                   || ';base64,';
        else
            return 'data:'
                   || p_mime_type
                   || ';charset='
                   || p_charset
                   || ';base64,';
        end if;
    end;

    procedure get_content (
        p_directory     in varchar2,
        p_file_name     in varchar2,
        p_file_mimetype out varchar2,
        p_file_base64   out clob
    ) is
        vsql varchar2(4000);
    begin
        if ( p_directory = 'A' ) then
            vsql := '
                    SELECT 
                        mime_type, apex_web_service.blob2clobbase64(file_content) 
                    FROM 
                        apex_application_static_files 
                    WHERE 
                        upper(file_name) = '
                    || chr(39)
                    || upper(p_file_name)
                    || chr(39)
                    || ' 
                    AND application_id = '
                    || appid
                    || ' ';
        elsif ( p_directory = 'W' ) then
            vsql := ' 
                    SELECT 
                        /* NOLOGGING */ 
                        mime_type, 
                        apex_web_service.blob2clobbase64(file_content) 
                    FROM 
                        apex_workspace_static_files 
                    WHERE 
                        upper(file_name) = '
                    || chr(39)
                    || upper(p_file_name)
                    || chr(39)
                    || ' 
                    AND workspace_id = '
                    || workspaceid
                    || ' ';
        end if;

        execute immediate vsql
        into
            p_file_mimetype,
            p_file_base64;
    end;

    procedure extension_to_mimetype (
        p_extention in varchar2,
        p_mimetype  out varchar2
    ) is
    begin
        if p_extention = 'pdf' then
            p_mimetype := 'application/pdf';
        elsif p_extention = 'html' then
            p_mimetype := 'text/html';
        elsif p_extention = 'xlsx' then
            p_mimetype := 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
        elsif p_extention = 'csv' then
            p_mimetype := 'text/csv';
        elsif p_extention = 'docx' then
            p_mimetype := 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
        elsif p_extention = 'json' then
            p_mimetype := 'application/json';
        end if;
    end;

    function mimetype_to_extension (
        p_mimetype in varchar2
    ) return varchar2 as
    begin
        if p_mimetype = 'application/pdf' then
            return 'pdf';
        elsif p_mimetype = 'text/html' then
            return 'html';
        elsif p_mimetype = 'application/vnd.openxmlformats-officedocument.wordprocessingml.document' then
            return 'docx';
        end if;
    end;

    function get_files_from_url (
        p_url              in varchar2,
        p_http_method      in varchar2 default 'GET',
        p_username         in varchar2 default null,
        p_password         in varchar2 default null,
        p_proxy_override   in varchar2 default null,
        p_transfer_timeout in number default 180,
        p_wallet_path      in varchar2 default null,
        p_wallet_password  in varchar2 default null
    ) return clob as

        l_content_type  varchar2(2000);
        l_vcheadername  varchar2(200);
        l_vcheadervalue varchar2(2000);
        l_result        clob;
        l_clob          clob;
        err_code        number;
        err_msg         clob;
    begin
        dbms_output.enable(1000000);
        l_clob := apex_web_service.make_rest_request(
            p_url              => p_url,
            p_http_method      => p_http_method,
            p_username         => p_username,
            p_password         => p_password,
            p_proxy_override   => p_proxy_override,
            p_transfer_timeout => p_transfer_timeout,
            p_wallet_path      => p_wallet_path,
            p_wallet_pwd       => p_wallet_password
        );

        return l_clob;
    exception
        when others then
            raise_error('Unable to fetch file');
    end get_files_from_url;

    function maxprint_call (
        p_dynamic_action in apex_plugin.t_dynamic_action,
        p_plugin         in apex_plugin.t_plugin
    ) return apex_plugin.t_dynamic_action_render_result as
        l_result apex_plugin.t_dynamic_action_render_result;
    begin
        apex_javascript.add_library(
            p_name      => 'maxprint_v2',
            p_directory => p_plugin.file_prefix,
            p_version   => null
        );

        apex_javascript.add_library(
            p_name      => 'print_v2.min',
            p_directory => p_plugin.file_prefix,
            p_version   => null
        );

        l_result.javascript_function := 'maxprint_render_v2';
        l_result.ajax_identifier := apex_plugin.get_ajax_identifier;
        l_result.attribute_01 := p_dynamic_action.attribute_01;
        l_result.attribute_10 := p_dynamic_action.attribute_10;
        l_result.attribute_13 := nvl(p_dynamic_action.attribute_13, 'D');
        return l_result;
    end maxprint_call;

    function maxprint_da_ajax (
        p_dynamic_action in apex_plugin.t_dynamic_action,
        p_plugin         in apex_plugin.t_plugin
    ) return apex_plugin.t_dynamic_action_ajax_result as

        -- L_API_CREATE_OR_EDIT              VARCHAR2(200) := 'https://appv2.maxprint.io/api/v1/redirect/';
        -- L_API_RUN_REPORT               VARCHAR2(200) := 'https://appv2.maxprint.io/api/v1/report/run/template/';
        l_api_create_or_edit    p_plugin.attribute_01%type := trim(p_plugin.attribute_01)
                                                           || '/redirect/';
        l_api_run_report        p_plugin.attribute_01%type := trim(p_plugin.attribute_01)
                                                       || '/report/run/template/';
        l_api_debug             p_plugin.attribute_01%type := trim(p_plugin.attribute_01)
                                                  || '/report/debug/';
        l_api_key               p_plugin.attribute_02%type := trim(p_plugin.attribute_02);
        l_wallet_path           varchar2(100) := null;
        l_wallet_key            varchar2(100) := null;
        -- L_WALLET_PATH                  P_PLUGIN.ATTRIBUTE_03%TYPE := TRIM(P_PLUGIN.ATTRIBUTE_03);
        -- L_WALLET_KEY                   P_PLUGIN.ATTRIBUTE_04%TYPE := TRIM(P_PLUGIN.ATTRIBUTE_04);
        -- L_EMAIL                        P_PLUGIN.ATTRIBUTE_05%TYPE := TRIM(P_PLUGIN.ATTRIBUTE_05);

        l_action                p_dynamic_action.attribute_01%type := p_dynamic_action.attribute_01;
        l_data_source_type      p_dynamic_action.attribute_02%type := trim(p_dynamic_action.attribute_02);
        l_sql_type              p_dynamic_action.attribute_03%type := p_dynamic_action.attribute_03;
        l_pl_code               p_dynamic_action.attribute_04%type := p_dynamic_action.attribute_04;
        l_sql_query             p_dynamic_action.attribute_05%type := trim(p_dynamic_action.attribute_05);
        l_query_master_cols     p_dynamic_action.attribute_06%type := trim(p_dynamic_action.attribute_06);
        l_template_source       p_dynamic_action.attribute_07%type := p_dynamic_action.attribute_07;
        l_template_name_url     p_dynamic_action.attribute_08%type := trim(p_dynamic_action.attribute_08);
        l_template_id           p_dynamic_action.attribute_09%type := trim(p_dynamic_action.attribute_09);
        l_output_type           p_dynamic_action.attribute_11%type := p_dynamic_action.attribute_11;
        l_output_filename       p_dynamic_action.attribute_12%type := nvl(p_dynamic_action.attribute_12, 'Output');
        l_template_json         clob := '';
        l_json                  clob;
        l_output_file           blob;
        l_output_file_mime_type varchar2(100);
        l_output_file_base64    clob;
        l_output_file_utf8      clob;
        l_link                  varchar2(100);
        l_error_messages        clob;
        l_development_mode      boolean := false;
        l_return                apex_plugin.t_dynamic_action_ajax_result;
        l_payload               clob;
        l_response              clob;
        l_redirect_url          varchar(4000);
    begin
        if apex_application.g_debug then
            apex_plugin_util.debug_dynamic_action(
                p_plugin         => p_plugin,
                p_dynamic_action => p_dynamic_action
            );
        end if;

        if apex_application.g_edit_cookie_session_id is not null then
            l_development_mode := true;
        end if;
        debug('Initializing values', 3);

            -- Check if either Template Name, URL or Template ID is provided
        if l_action in ( 'R', 'E' ) then
            if
                l_template_name_url is null
                and l_template_id is null
            then
                l_output_file_base64 := 'Template Name, Template URL or Template ID must be provided.';
                maxprint_plsql_api_v2.print_payload(l_output_file_base64);
                return l_return;
            end if;

                -- Fetching template
            debug('Fetching template '
                  || l_template_name_url
                  || ' '
                  || l_template_id
                  || ' started ', 3);

            begin
                if l_template_source = 'A' then
                    l_template_json := maxprint_plsql_api_v2.get_apex_directory_content_json(
                        p_directory => 'A',
                        p_file_name => upper(l_template_name_url)
                    );

                elsif l_template_source = 'W' then
                    l_template_json := maxprint_plsql_api_v2.get_apex_directory_content_json(
                        p_directory => 'W',
                        p_file_name => upper(l_template_name_url)
                    );
                elsif l_template_source = 'S' then
                    l_template_json := get_files_from_url(
                        p_url             => l_template_name_url,
                        p_wallet_path     => l_wallet_path,
                        p_wallet_password => l_wallet_key
                    );
                elsif l_template_source = 'T' then
                    l_template_id := trim(p_dynamic_action.attribute_09);
                end if;
            exception
                when no_data_found then
                    l_output_file_base64 := 'Template Not Found.';
                    maxprint_plsql_api_v2.print_payload(l_output_file_base64);
                    return l_return;
                when others then
                    l_output_file_base64 := 'Error Occurred While Fetching Template.';
                    maxprint_plsql_api_v2.print_payload(l_output_file_base64);
                    return l_return;
            end;

        end if;

        begin
            debug('Sql Data Processing Begin.', 3);
            if ( l_data_source_type = 'FRS' ) then
                l_json := maxprint_json_utils_v2.get_json_from_plsql(
                    pl_code          => l_pl_code,
                    p_datasoure_type => l_data_source_type
                );
            elsif ( l_data_source_type = 'SQL' ) then
                l_json := maxprint_json_utils_v2.get_json_from_sql(
                    p_sql               => l_sql_query,
                    p_sql_type          => l_sql_type,
                    p_query_master_cols => l_query_master_cols
                );
            end if;

            debug('Sql Data Processing Complete.', 3);
        exception
            when others then
                debug(sqlerrm, 2);
                l_output_file_base64 := 'Error Evaluating Query. Check if you have selected correct query type';
                maxprint_plsql_api_v2.print_payload(l_output_file_base64);
                return l_return;
        end;

        extension_to_mimetype(l_output_type, l_output_file_mime_type);
        if l_action in ( 'C', 'E' ) then

                -- IF (L_TEMPLATE_JSON IS NOT NULL) THEN
                --     L_PAYLOAD := to_clob('{"email":"' || L_EMAIL || '","template_id":"' || L_TEMPLATE_ID || '","template":' || L_TEMPLATE_JSON || ',"key":"' || L_API_KEY || '","data_source":' || L_JSON || '}');
                -- ELSE
                --     L_PAYLOAD := to_clob('{"email":"' || L_EMAIL || '","template_id":"' || L_TEMPLATE_ID || '","template":"","key":"' || L_API_KEY || '","data_source":' || L_JSON || '}');
                -- END IF;
            if ( l_template_json is not null ) then
                l_payload := to_clob('{"template_id":"'
                                     || l_template_id
                                     || '","template":'
                                     || l_template_json
                                     || ',"key":"'
                                     || l_api_key
                                     || '","data_source":'
                                     || l_json || '}');
            else
                l_payload := to_clob('{"template_id":"'
                                     || l_template_id
                                     || '","template":"","key":"'
                                     || l_api_key
                                     || '","data_source":'
                                     || l_json || '}');
            end if;

            l_response := maxprint_plsql_api_v2.maxprint_api_call(
                p_url         => l_api_create_or_edit,
                p_data        => l_payload,
                p_output_type => null,
                p_api_key     => null
            );

                -- CHECK STATUS CODE
            if apex_web_service.g_status_code = 200 then
                l_redirect_url := json_value(l_response, '$.redirect_url');
                l_output_file_base64 := generate_response_body(
                    p_file_name    => l_output_filename,
                    p_mime_type    => l_output_file_mime_type,
                    p_redirect_url => l_redirect_url,
                    p_data         => null
                );

            else
                    -- If status is NOT 200, parse the error from the response
                l_error_messages := parse_error_code(apex_web_service.g_status_code);
                if l_error_messages is null then
                       -- Use the helper function to get the 'error' field from the API JSON
                    l_error_messages := parse_errors(l_response);
                end if;

                    -- Send ONLY the error text string
                l_output_file_base64 := l_error_messages;
            end if;

            maxprint_plsql_api_v2.print_payload(l_output_file_base64);
            return l_return;
        elsif ( l_action = 'R' ) then
            if ( l_output_type = 'M' ) then
                l_link := l_api_debug;
            else
                l_link := l_api_run_report;
            end if;

            begin
                debug('Maxprint Request Started', 3);
                l_output_file_utf8 := maxprint_plsql_api_v2.maxprint_api_call(
                    p_url              => l_link,
                    p_api_key          => l_api_key,
                    p_template         => l_template_json,
                    p_template_id      => l_template_id,
                    p_data             => l_json,
                    p_output_type      => l_output_type,
                    p_wallet_path      => l_wallet_path,
                    p_wallet_password  => l_wallet_key,
                    p_debug            => apex_application.g_debug,
                    p_development_mode => l_development_mode
                );

                debug('Maxprint Rest Request Completed', 3);
                if ( apex_web_service.g_status_code = 200
                or l_output_type = 'M' ) then
                    htp.init;
                    debug('File Recieved', 3);
                    debug('Creating Response Body', 3);
                    l_output_file_base64 := generate_response_body(
                        p_file_name    => l_output_filename
                                       || '.'
                                       || nvl((
                            case
                                when l_output_type = 'M' then
                                    'json'
                                else
                                    l_output_type
                            end
                        ), 'pdf'),
                        p_mime_type    => l_output_file_mime_type,
                        p_redirect_url => null,
                        p_data         => l_output_file_utf8
                    );

                    maxprint_plsql_api_v2.print_payload(l_output_file_base64);
                else
                    l_error_messages := parse_error_code(apex_web_service.g_status_code);
                    if l_error_messages is null then
                        l_error_messages := initcap(nvl(
                            replace(
                                replace(
                                    parse_errors(l_output_file_utf8),
                                    chr(10),
                                    ''
                                ),
                                chr(13),
                                ''
                            ),
                            l_output_file_utf8
                        ));

                    end if;

                    l_output_file_base64 := l_error_messages;
                    maxprint_plsql_api_v2.print_payload(l_output_file_base64);
                    debug('Function Returned '
                          || apex_web_service.g_status_code
                          || ','
                          || apex_web_service.g_reason_phrase, 2);

                end if;

                return l_return;
            end;

        end if;

    end;

end maxprint_utils_v2;
/


-- sqlcl_snapshot {"hash":"ab55cc19c5be2b40d24e929b1fda8bb3357d50e7","type":"PACKAGE_BODY","name":"MAXPRINT_UTILS_V2","schemaName":"MAXPRINT_DEV","sxml":""}