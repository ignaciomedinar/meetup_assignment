with base as (
	select
		dt.topic_name,
		count(distinct fgt.group_id) as groups_count,
		count(distinct fe.event_id) as events_count,
		round((
			count(distinct case when fr.response = 'yes' then fr.user_id else 0 end)
			+ sum(case when fr.response = 'yes' then fr.guests else 0 end)
		)
		/ nullif(events_count, 0), 2) as avg_attendance
	from {{ ref('dim_topics') }} as dt
	left join {{ ref('fact_group_topics') }} as fgt
		on dt.topic_id = fgt.topic_id
	left join {{ ref('fact_events') }} as fe
		on fgt.group_id = fe.group_id
	left join {{ ref('fact_rsvp') }} as fr
		on fe.event_id = fr.event_id
	group by dt.topic_name
)

select
	*,
	{{ dbt_date.now() }} as loaded_at
from base
