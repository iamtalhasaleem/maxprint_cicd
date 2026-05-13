create or replace package body maxprint_dev.maxprint_plsql_api_v2 as

    procedure print_payload (
        p_text in out nocopy clob
    ) is

        v_temp   varchar2(4000);
        v_clob   clob := p_text;
        v_amount number := 4000;
        v_offset number := 1;
        v_length number := dbms_lob.getlength(p_text);
    begin
        while v_length >= v_offset loop
            v_temp := dbms_lob.substr(v_clob, v_amount, v_offset);
            htp.prn(v_temp);
            v_offset := v_offset + length(v_temp);
        end loop;
    end;

    procedure debug_requests (
        p_url        in varchar2 default null,
        p_identifier in varchar2 default null,
        p_request    in clob default null,
        p_debug      in boolean default false
    ) is
        pragma autonomous_transaction;
    begin
        if p_debug then
            insert into maxprint_debug_requests_v2 (
                identifier,
                url,
                request
            ) values ( p_identifier,
                       p_url,
                       p_request );

            commit;
        end if;
    end;

    procedure dbms_print_payload (
        p_text in out nocopy clob
    ) is

        v_temp   varchar2(4000);
        v_clob   clob := p_text;
        v_amount number := 4000;
        v_offset number := 1;
        v_length number := dbms_lob.getlength(p_text);
    begin
        while v_length >= v_offset loop
            v_temp := dbms_lob.substr(v_clob, v_amount, v_offset);
            dbms_output.put_line(v_temp);
            v_offset := v_offset + length(v_temp);
        end loop;
    end dbms_print_payload;

    function get_apex_directory_content_json (
        p_directory in varchar2,
        p_file_name in varchar2,
        p_app       in varchar2 default v_app_id,
        p_workspace in varchar2 default v_workspace_id
    ) return clob is

        l_blob      blob;
        l_content   clob;
        l_file_name varchar2(1000);
        l_cs_id     pls_integer := nls_charset_id('AL32UTF8'); -- your JSON files are text/UTF-8  'AL32UTF8'
        l_do        pls_integer := 1; -- dest offset
        l_so        pls_integer := 1; -- src offset
        l_wc        pls_integer := 0; -- lang context
        l_warn      pls_integer;
    begin
        l_file_name := p_file_name || '.json';
        if p_directory = 'A' then
            select
                file_content
            into l_blob
            from
                apex_application_static_files
            where
                    upper(file_name) = upper(l_file_name)
                and application_id = p_app;

        elsif p_directory = 'W' then
            select
                file_content
            into l_blob
            from
                apex_workspace_static_files
            where
                    upper(file_name) = upper(l_file_name)
                and workspace_id = p_workspace;

        else
            raise_application_error(-20001, 'Invalid directory. Use A (Application) or W (Workspace).');
        end if;

        dbms_lob.createtemporary(l_content, true);
        dbms_lob.converttoclob(l_content, l_blob, dbms_lob.lobmaxsize, l_do, l_so,
                               l_cs_id, l_wc, l_warn);

        return l_content;
    exception
        when no_data_found then
            raise_application_error(-20002, 'JSON file not found.');
        when others then
            raise;
    end;

    function get_json_from_plsql (
        pl_code          in clob,
        p_datasoure_type varchar2 default 'FRS'
    ) return clob as
    begin
        return maxprint_json_utils_v2.get_json_from_plsql(
            pl_code          => pl_code,
            p_datasoure_type => p_datasoure_type
        );
    end;

    function get_json_from_sql (
        p_sql               in clob,
        p_sql_type          in varchar2,
        p_query_master_cols varchar2 default null
    ) return clob as
    begin
        return maxprint_json_utils_v2.get_json_from_sql(
            p_sql               => p_sql,
            p_sql_type          => p_sql_type,
            p_query_master_cols => p_query_master_cols
        );
    end;

    function get_json_from_refcursor (
        p_refcursor in sys_refcursor
    ) return clob as
    begin
        return maxprint_json_utils_v2.get_json_from_refcursor(p_refcursor);
    end;

    function clobtoblob (
        c in clob
    ) return blob is

        b     blob;
        warn  varchar2(255);
        cs_id number := nls_charset_id('AL32UTF8');
        do    number := 1; -- dest offset 
        so    number := 1; -- src offset 
        lc    number := 0; -- lang context
    begin
        dbms_lob.createtemporary(b, true);
        dbms_lob.converttoblob(b, c, dbms_lob.lobmaxsize, do, so,
                               cs_id, lc, warn);

        return b;
    end clobtoblob;

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
    ) return clob is
        l_request_body     clob;
        l_output_file_utf8 clob;
        l_wallet_path      varchar2(500);
        l_wallet_password  varchar2(1000);
    begin

                -- Only set Authorization header if API key is provided
        if
            p_api_key is not null
            and trim(p_api_key) is not null
        then
            apex_web_service.g_request_headers(1).name := 'MAXPRINT-API-KEY';
            apex_web_service.g_request_headers(1).value := p_api_key;
            apex_web_service.g_request_headers(2).name := 'Content-Type';
            apex_web_service.g_request_headers(2).value := 'application/json';
        else
                -- Only Content-Type header if no API key
            apex_web_service.g_request_headers(1).name := 'Content-Type';
            apex_web_service.g_request_headers(1).value := 'application/json';
        end if;

        sys.htp.init;
        apex_json.initialize_clob_output;
        apex_json.open_object;
        apex_json.write('data', p_data);
        apex_json.write('template', p_template);
        apex_json.write('template_id', p_template_id);
        apex_json.write('outputFormat', p_output_type);
        apex_json.write('development_mode', p_development_mode);
        apex_json.write('isTestData', true);
        apex_json.close_all;
        l_request_body := apex_json.get_clob_output;
        apex_json.free_output;
        debug_requests(
            p_url        => p_url,
            p_identifier => p_api_key,
            p_request    => l_request_body,
            p_debug      => p_debug
        );

            -- if p_output_type = 'M' then
                -- apex_json.initialize_clob_output;
                -- apex_json.open_object;
                -- apex_json.write('identifier' , p_api_key);
                -- apex_json.write('url'        , p_url);
                -- apex_json.write('request'    , l_request_body);
                -- apex_json.write('create_time', sysdate);      
                -- apex_json.close_all;
                      
                -- l_output_file_utf8  := apex_json.get_clob_output;
                -- apex_json.free_output;
                  
                -- l_output_file_utf8 := apex_web_service.blob2clobbase64(clobToBlob(l_output_file_utf8));

            -- else
            --     if p_wallet_path is not null then 
            --         l_wallet_path := 'file:' || p_wallet_path;
            --         l_wallet_password := p_wallet_password;
            --     end if;

            --     l_output_file_utf8 := apex_web_service.make_rest_request(
            --         p_url              => p_url,
            --         p_http_method      => 'POST',
            --         p_body             => l_request_body,
            --         p_transfer_timeout => p_timeout,
            --         p_wallet_path      => l_wallet_path,          
            --         p_wallet_pwd       => l_wallet_password);
            -- end if;
        if p_wallet_path is not null then
            l_wallet_path := 'file:' || p_wallet_path;
            l_wallet_password := p_wallet_password;
        end if;

        l_output_file_utf8 := apex_web_service.make_rest_request(
            p_url              => p_url,
            p_http_method      => 'POST',
            p_body             => l_request_body,
            p_transfer_timeout => p_timeout,
            p_wallet_path      => l_wallet_path,
            p_wallet_pwd       => l_wallet_password
        );

        return l_output_file_utf8;
    end;

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
    ) return clob as
    begin
        return maxprint_api_call(
            p_url              => p_url,
            p_api_key          => p_api_key,
            p_data             => p_data,
            p_output_type      => p_output_type,
            p_template_id      => p_template_id,
            p_template         => p_template,
            p_wallet_path      => p_wallet_path,
            p_wallet_password  => p_wallet_password,
            p_timeout          => p_timeout,
            p_debug            => p_debug,
            p_development_mode => p_development_mode
        );
    end;

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
    ) return blob as
    begin
        return apex_web_service.clobbase642blob(maxprint_api_call(
            p_url              => p_url,
            p_api_key          => p_api_key,
            p_data             => p_data,
            p_output_type      => p_output_type,
            p_template_id      => p_template_id,
            p_template         => p_template,
            p_wallet_path      => p_wallet_path,
            p_wallet_password  => p_wallet_password,
            p_timeout          => p_timeout,
            p_debug            => p_debug,
            p_development_mode => p_development_mode
        ));
    end;

end maxprint_plsql_api_v2;
/


-- sqlcl_snapshot {"hash":"dacfea7534c9e3421a4e3eac5158bc7c5e44192d","type":"PACKAGE_BODY","name":"MAXPRINT_PLSQL_API_V2","schemaName":"MAXPRINT_DEV","sxml":""}