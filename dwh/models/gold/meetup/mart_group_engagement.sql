with base as (
	select
		group_name,
		dg.group_city,
		dg.group_created_at::date as group_created_at,
		min(fe.event_time)::date as first_event_date,
		max(fe.event_time)::date as last_event_date,
		count(distinct fgt.topic_id) as topics_count,
		date_diff(max(fe.event_time), min(fe.event_time)) as days_active,
		count(distinct event_id) as events_count,
		count(distinct fm.user_id) as user_count,
		round(events_count / nullif(user_count, 0), 2) as events_per_members
	from {{ ref('dim_groups') }} as dg
	left join {{ ref('fact_events') }} as fe
		on dg.group_id = fe.group_id
	left join {{ ref('fact_memberships') }} as fm
		on dg.group_id = fm.group_id
	left join {{ ref('fact_group_topics') }} as fgt
		on dg.group_id = fgt.group_id
	group by
		group_name,
		dg.group_city,
		dg.group_created_at::date
)

select
	*,
	{{ dbt_date.now() }} as loaded_at
from base
