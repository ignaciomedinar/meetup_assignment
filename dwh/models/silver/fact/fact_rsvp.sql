{{
    config(
        unique_key= 'row_hash'
    )
}}

with base as (
	select distinct
		de.event_id,
		name as event_name,
		r.user_id,
		r.guests,
		r.response,
		from_unixtime(r.when / 1000)::timestamp as rsvp_at,
		{{ dbt_utils.generate_surrogate_key(['name', 'r.user_id', 'r.guests', 'r.response']) }} as row_hash,
		{{ dbt_date.now() }} as loaded_at
	from {{ ref('raw_events') }} as re
	left join {{ ref('dim_events') }} as de
		on re.name = de.event_name
		lateral view explode(rsvps) as r
)

select *
from base

{% if is_incremental() %}
	where row_hash not in (select row_hash from {{ this }})
{% endif %}
