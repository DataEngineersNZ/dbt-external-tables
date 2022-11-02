{% macro snowflake__refresh_external_table(relation, source_node) %}

    {% set external = source_node.external %}
    {% set snowpipe = source_node.external.get('snowpipe', none) %}
    
    {% set auto_refresh = external.get('auto_refresh', false) %}
    {% set partitions = external.get('partitions', none) %}
    
    {% set manual_refresh = (partitions and not auto_refresh) %}
    
    {% if manual_refresh %}

        {% set ddl %}
        begin;
        alter external table {{ relation.include(database=(not temporary), schema=(not temporary)) }} refresh;
        commit;
        {% endset %}
        
        {% do return([ddl]) %}
    
    {% else %}
    
        {% do return([]) %}
    
    {% endif %}
    
{% endmacro %}
