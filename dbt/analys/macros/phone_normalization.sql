{% macro normalize_phone_number(column_name) %}
    regexp_replace(replace(replace(ltrim({{ column_name }}, '+'), '-', ''), ' ', ''), '[^0-9]', '')
{% endmacro %}
