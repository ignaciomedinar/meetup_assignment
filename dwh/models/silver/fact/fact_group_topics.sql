{{
    config(
        unique_key= 'row_hash'
    )
}}

with groups as (
	select distinct
		group_id,
		topic
	from {{ ref('raw_groups') }}
		lateral view explode(topics) as topic
),

base as (
	select
		group_id,
		dt.topic_id,
		{{ dbt_utils.generate_surrogate_key(['group_id', 'topic_id']) }} as row_hash,
		{{ dbt_date.now() }} as loaded_at
	from groups
	left join {{ ref('dim_topics') }} as dt
		on topic = dt.topic_name
)

select *
from base

{% if is_incremental() %}
	where row_hash not in (select row_hash from {{ this }})
{% endif %}
