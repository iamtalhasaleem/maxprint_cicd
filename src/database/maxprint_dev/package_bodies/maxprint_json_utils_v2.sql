create or replace package body maxprint_dev.maxprint_json_utils_v2 as

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

    function replace_binds (
        p_sql_in in clob
    ) return clob is
        v_sql    clob;
        v_names  dbms_sql.varchar2_table;
        v_pos    number;
        v_length number;
    begin
        v_sql := p_sql_in;
        v_names := wwv_flow_utilities.get_binds(v_sql);
        for i in 1..v_names.count loop
            << do_it_again >> v_pos := instr(
                lower(v_sql),
                lower(v_names(i))
            );

            v_length := length(lower(v_names(i)));
            v_sql := substr(v_sql, 1, v_pos - 1)
                     || v_names(i)
                     || substr(v_sql, v_pos + v_length);

            v_sql := replace(v_sql,
                             upper(v_names(i)),
                             'v('''
                             || ltrim(
                                     v_names(i),
                                     ':'
                                 )
                             || ''')');

            if instr(
                lower(v_sql),
                lower(v_names(i))
            ) > 0 then
                goto do_it_again;
            end if;

        end loop;

        return v_sql;
    end replace_binds;

    -- FUNCTION REMOVE_LINEBREAKS (P_TEXT IN CLOB) RETURN CLOB AS
    --     BEGIN
    --         RETURN REPLACE(REPLACE(RTRIM(TRIM(P_TEXT), ';'), CHR(13), CHR(32)), CHR(10), CHR(32));
    --     END;

    -- New function to handle comment removal
    function remove_comments (
        p_text in clob
    ) return clob as
        l_text clob;
    begin
        l_text := p_text;

        -- 1. Remove multi-line comments /* ... */
        -- The 'n' flag allows the '.' to match newline characters
        l_text := regexp_replace(l_text, '/\*.*?\*/', '', 1, 0,
                                 'n');

        -- 2. Remove single-line comments -- ...
        -- The 'm' flag makes '^' and '$' match the start/end of every line
        l_text := regexp_replace(l_text, '--.*$', '', 1, 0,
                                 'm');
        return l_text;
    end;

    function remove_linebreaks (
        p_text in clob
    ) return clob as
        l_text clob;
    begin
        -- 1. Remove all leading and trailing whitespace, including newlines
        l_text := regexp_replace(p_text, '^[[:space:]]+|[[:space:]]+$', '');
        
        -- 2. Remove the trailing semicolon if it exists
        l_text := rtrim(l_text, ';');
        
        -- 3. Remove "middle" blank lines by collapsing sequences of 2 or more 
        --    line breaks (with optional whitespace between them) into a single line break.
        --    This handles both Windows (\r\n) and Unix (\n) styles.
        l_text := regexp_replace(l_text,
                                 '('
                                 || chr(13)
                                 || '?'
                                 || chr(10)
                                 || '[[:space:]]*){2,}',
                                 chr(10));

        -- 4. Convert all remaining single line breaks into spaces (existing logic)
        --    This flattens the query into a single line without extra gaps.
        return replace(
            replace(l_text,
                    chr(13),
                    chr(32)),
            chr(10),
            chr(32)
        );

    end;

    function sql_treatment (
        p_sql in clob
    ) return clob is
        l_code clob;
    begin

            /* 1. Remove single and multiline comments first while line breaks still exist */
            -- L_CODE := REMOVE_COMMENTS(P_SQL);
           
            /*Remove Semi colon, extra lines if added and flattens the query*/
        l_code := remove_linebreaks(p_sql);
         
            /*Replace bind variables wiht v()*/
        l_code := replace_binds(l_code);
        return l_code;
    end;

    function simplesql2json (
        query                in clob,
        master_column_source in varchar2 default null
    ) return clob is

        v_wrapper_begin       varchar2(7) := 'select ';
        v_wrapper_columns     varchar2(1) := '*';
        v_wrapper_dataset     varchar2(6) := 'from (';
        v_wrapper_end         varchar2(1) := ')';
        v_master_column_names clob := master_column_source;
        v_query               clob := query;
        v_det_column_names    varchar2(4000);
        l_cursor              sys_refcursor;
        v_final_query         clob := '';
        v_json_output         clob;

        function check_for_column (
            v_column_list  in varchar2,
            v_lookup_value in varchar2
        ) return boolean is
            v_cnt number;
        begin
            select
                count(*)
            into v_cnt
            from
                (
                    select
                        regexp_substr(v_column_list, '[^,]+', 1, level) column_name
                    from
                        dual
                    connect by
                        regexp_substr(v_column_list, '[^,]+', 1, level) is not null
                )
            where
                column_name = v_lookup_value;

            if v_cnt > 0 then
                return true;
            else
                return false;
            end if;
        exception
            when others then
                return null;
        end;

        function return_detail_columns (
            p_sql             in clob,
            exclusive_columns in clob
        ) return clob is
            c              number;
            rows_processed number;
            col_cnt        integer;
            rec_tab        dbms_sql.desc_tab;
            v_column_names clob;
        begin
            if p_sql is not null then
                c := dbms_sql.open_cursor;
                dbms_sql.parse(c, p_sql, dbms_sql.native);
                rows_processed := dbms_sql.execute(c);
                dbms_sql.describe_columns(c, col_cnt, rec_tab);
                for j in 1..col_cnt loop
                    if not check_for_column(exclusive_columns,
                                            rec_tab(j).col_name) then
                        v_column_names := v_column_names
                                          || ','
                                          || rec_tab(j).col_name;
                    end if;
                end loop;

                return substr(v_column_names, 2);
            end if;
        end;

        function return_join_conditions (
            column_source       in varchar2,
            master_table_allias in varchar2,
            detail_table_allias in varchar2
        ) return clob as
            v_resultant_joins clob;
        begin
            select
                listagg(new_val, ' and ') within group(
                order by
                    1
                )
            into v_resultant_joins
            from
                (
                    select
                        'NVL( TO_CHAR('
                        || master_table_allias
                        || '.'
                        || val
                        || ') ,0) = NVL( TO_CHAR('
                        || detail_table_allias
                        || '.'
                        || val
                        || ') ,0)' new_val
                    from
                        (
                            select
                                regexp_substr(column_source, '[^,]+', 1, level) val
                            from
                                dual
                            connect by
                                regexp_substr(column_source, '[^,]+', 1, level) is not null
                        ) x
                );

            return v_resultant_joins;
        end return_join_conditions;

        function return_dynamic_sql_json_obj (
            column_string in varchar2
        ) return clob is
            v_resultant_joins clob;
        begin
            select
                listagg(new_val, ' , ') within group(
                order by
                    1
                )
            into v_resultant_joins
            from
                (
                    select
                        chr(39)
                        || val
                        || chr(39)
                        || ' value '
                        || val as new_val
                    from
                        (
                            select
                                regexp_substr(column_string, '[^,]+', 1, level) val
                            from
                                dual
                            connect by
                                regexp_substr(column_string, '[^,]+', 1, level) is not null
                        ) x
                );

            return v_resultant_joins;
        end;

    begin
        if master_column_source is null then
            debug(
                p_message => 'executing query begins',
                p_level   => 3
            );
            open l_cursor for v_query;

            apex_json.initialize_clob_output;
            apex_json.write(l_cursor);
            v_json_output := apex_json.get_clob_output;
            apex_json.free_output;
            debug(
                p_message => 'executing query ends',
                p_level   => 3
            );
        else
            v_det_column_names := return_detail_columns(v_wrapper_begin
                                                        || v_wrapper_columns
                                                        || v_wrapper_dataset
                                                        || v_query
                                                        || v_wrapper_end, v_master_column_names);

            v_final_query := 'with x as ('
                             || v_query
                             || '
                ),
                m as (select /*+MATERIALIZE*/  distinct '
                             || v_master_column_names
                             || ' from x)
                SELECT
                                 JSON_ARRAYAGG(JSON_OBJECT('
                             || return_dynamic_sql_json_obj(v_master_column_names)
                             || ',
                                                                          ''DETAIL'' VALUE(
                                                                    SELECT
                                                                        JSON_ARRAYAGG(JSON_OBJECT(
                                                                                          '
                             || return_dynamic_sql_json_obj(v_det_column_names)
                             || '
                                                                                      RETURNING CLOB) RETURNING CLOB)
                                                                    FROM
                                                                        x v
                                                                    where
                                                                    '
                             || return_join_conditions(v_master_column_names, 'c', 'v')
                             || '
                                                                )
                                                            RETURNING CLOB)
                                                            RETURNING CLOB)
                                          FROM
                                              m c ';

            debug(v_final_query, 3);
            execute immediate v_final_query
            into v_json_output;
                     /*v_json_output := MAXPRINT_JSON_UTILS.sql2json(v_final_query);*/
        end if;

        return v_json_output;
    end;

    function sql2json (
        p_sql in clob
    ) return clob is
        v_sql            clob;
        v_json           clob;
        v_cursor         binary_integer;
        v_rows_processed binary_integer;
        v_refcur         sys_refcursor;
    begin
        v_sql := 'select '
                 || chr(39)
                 || 'x'
                 || chr(39)
                 || ' x , cursor('
                 || p_sql
                 || ') data from dual';

        v_cursor := dbms_sql.open_cursor;
        dbms_sql.parse(v_cursor, v_sql, dbms_sql.native);
        v_rows_processed := dbms_sql.execute(v_cursor);
        v_refcur := dbms_sql.to_refcursor(v_cursor);
        apex_json.initialize_clob_output;
        apex_json.write(v_refcur);
        v_json := apex_json.get_clob_output;
        apex_json.free_output;
        v_json := trim(v_json);
        v_json := json_query(v_json, '$[0].DATA' with conditional wrapper);
        return v_json;
    end;

    function get_json_from_plsql (
        pl_code          in clob,
        p_datasoure_type varchar2
    ) return clob as
        l_code   clob;
        l_sql    clob;
        l_result clob;
    begin
        l_code := remove_comments(pl_code);
        l_code := remove_linebreaks(l_code);
        debug(l_code, 3);
        if p_datasoure_type = 'FRS' then
            l_sql := apex_plugin_util.get_plsql_func_result_clob(p_plsql_function => l_code);
            l_sql := sql_treatment(l_sql);
            debug(l_sql, 3);
            if ( regexp_like(
                upper(l_sql),
                '(JSON_ARRAYAGG|JSON_ARRAY|JSON_OBJECT|JSON_OBJECTAGG)'
            ) ) then
                execute immediate l_sql
                into l_result;
            else
                l_result := sql2json(l_sql);
            end if;

        end if;

        return '{"report":'
               || l_result
               || '}';
    end;

    function get_json_from_sql (
        p_sql               in clob,
        p_sql_type          varchar2,
        p_query_master_cols varchar2 default null
    ) return clob as
        l_query_master_cols varchar2(4000) := p_query_master_cols;
        l_sql_query         clob;
        l_json              clob;
        l_code              clob;
    begin
        l_code := remove_comments(p_sql);
        l_sql_query := sql_treatment(l_code);
        debug(
            p_message => 'SQL Type is  '
                         || p_sql_type
                         || ' Query is '
                         || l_sql_query,
            p_level   => 3
        );

        if p_sql_type = 'J' then
             /*In case of JSON_OBJECT_SQL*/
            execute immediate l_sql_query
            into l_json;
        elsif p_sql_type = 'C' then
             /*In case of CURSOR*/
            l_json := sql2json(l_sql_query);
        elsif p_sql_type = 'S' then
             /*In case of SIMPLE SQL*/
            l_json := simplesql2json(
                query                => l_sql_query,
                master_column_source => l_query_master_cols
            );
             /*------------------------------------------------------------------------------*/
        end if;

        if ( length(l_json) <= 4 ) then
            raise no_data_found;
        end if;
        return '{"report":'
               || l_json
               || '}';
    end get_json_from_sql;

    function get_json_from_region (
        p_app_id           number,
        p_page_id          number,
        p_region_static_id varchar2
    ) return clob as
        v_region_id   number;
        v_region_name varchar2(100);
        v_report      apex_ir.t_report;
        v_query       varchar2(32767);
    begin
        debug(
            p_message => 'get_json_from_region start: '
                         || p_app_id
                         || ','
                         || p_page_id
                         || ','
                         || p_region_static_id,
            p_level   => 3
        );

        select
            region_id,
            region_name
        into
            v_region_id,
            v_region_name
        from
            apex_application_page_regions
        where
                application_id = p_app_id
            and page_id = p_page_id
            and static_id = p_region_static_id;

        debug(
            p_message => 'get_json_from_region 2nd step '
                         || v_region_id
                         || ','
                         || v_region_name,
            p_level   => 3
        );

        v_report := apex_ir.get_report(
            p_page_id   => p_page_id,
            p_region_id => v_region_id
        );
        v_query := v_report.sql_query;
        debug(
            p_message => 'get_json_from_region query ' || v_query,
            p_level   => 3
        );
        return v_query;
    end;

    function get_json_from_refcursor (
        p_refcursor in sys_refcursor
    ) return clob as
        vjson   clob;
        vcursor sys_refcursor := p_refcursor;
    begin
        apex_json.initialize_clob_output;
        apex_json.write('report', vcursor);
        vjson := apex_json.get_clob_output;
        apex_json.free_output;
        return vjson;
    end;

end maxprint_json_utils_v2;
/


-- sqlcl_snapshot {"hash":"38c2b652b72eee645157d2796ca5bdcda6bd977a","type":"PACKAGE_BODY","name":"MAXPRINT_JSON_UTILS_V2","schemaName":"MAXPRINT_DEV","sxml":""}