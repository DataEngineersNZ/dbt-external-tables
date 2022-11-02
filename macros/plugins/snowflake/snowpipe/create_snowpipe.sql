{% macro snowflake_create_snowpipe(relation, source_node) %}

    {%- set external = source_node.external -%}
    {%- set snowpipe = external.snowpipe -%}

{# https://docs.snowflake.com/en/sql-reference/sql/create-pipe.html #}
    create or replace pipe {{ relation.include(database=(not temporary), schema=(not temporary)) }}
        {% if snowpipe.auto_ingest -%} auto_ingest = {{snowpipe.auto_ingest}} {%- endif %}
        {% if snowpipe.aws_sns_topic -%} aws_sns_topic = '{{snowpipe.aws_sns_topic}}' {%- endif %}
        {% if snowpipe.integration -%} integration = '{{snowpipe.integration}}' {%- endif %}
        {% if snowpipe.error_integration -%} error_integration = '{{snowpipe.error_integration}}' {%- endif %}
        as {{ dbt_external_tables.snowflake_get_copy_sql(relation, source_node) }}

{% endmacro %}
