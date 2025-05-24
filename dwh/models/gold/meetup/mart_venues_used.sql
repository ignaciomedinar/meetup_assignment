with base as (
	select
		dv.venue_name,
		dv.venue_city,
		dv.venue_country,
		count(distinct fe.event_id) as events_count
	from {{ ref('dim_venues') }} as dv
	left join {{ ref('fact_events') }} as fe
		on dv.venue_id = fe.venue_id
	group by
		dv.venue_name,
		dv.venue_city,
		dv.venue_country
)

select
	*,
	{{ dbt_date.now() }} as loaded_at
from base
