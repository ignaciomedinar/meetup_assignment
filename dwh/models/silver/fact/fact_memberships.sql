{{
    config(
        unique_key= 'row_hash'
    )
}}

with base as (
	select
		user_id,
		m.group_id,
		from_unixtime(m.joined / 1000)::timestamp as joined_at,
		{{ dbt_utils.generate_surrogate_key(['user_id', 'm.group_id', 'joined_at']) }} as row_hash,
		{{ dbt_date.now() }} as loaded_at
	from {{ ref('raw_users') }}
		lateral view explode(memberships) as m
)

select *
from base

{% if is_incremental() %}
	where row_hash not in (select row_hash from {{ this }})
{% endif %}
