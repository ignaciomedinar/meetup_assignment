{{
    config(
        unique_key ='topic_name',
        materialized = 'incremental'
    )
}}

with topic as (
	select distinct topic as topic_name
	from {{ ref('raw_groups') }}
		lateral view explode(topics) as topic
)

select
{% if is_incremental() %}
		row_number() over (
			order by topic_name
		) + (select max(topic_id) from {{ this }}) as topic_id,
		topic_name,
		{{ dbt_date.now() }} as loaded_at
{% else %}  
        row_number() over (order by topic_name) as topic_id,
        topic_name,
        {{ dbt_date.now() }} as loaded_at
    {% endif %}  

from topic
