with events_created as (
	select
		event_created_at::date as event_created_at,
		count(distinct event_id) as events_created_count
	from {{ ref('fact_events') }}
	group by
		event_created_at::date
),

events_ocurred as (
	select
		event_time::date as event_time,
		count(distinct event_id) as events_ocurred_count
	from {{ ref('fact_events') }}
	group by
		event_time::date

),

groups as (
	select
		group_created_at::date as group_created_at,
		count(distinct group_id) as group_created_count
	from {{ ref('dim_groups') }}
	group by
		group_created_at::date
),

memberships as (
	select
		joined_at::date as joined_at,
		count(distinct user_id) as members_joined_group_count
	from {{ ref('fact_memberships') }}
	group by
		joined_at::date
),

rsvp as (
	select
		rsvp_at::date as rsvp_at,
		count(distinct user_id) as members_rsvp_count
	from {{ ref('fact_rsvp') }}
	group by
		rsvp_at::date
)

select
	date_key,
	dc.calendar_date,
	dc.week_start,
	dc.weekday_name,
	dc.month_start,
	coalesce(ec.events_created_count, 0) as events_created_count,
	coalesce(eo.events_ocurred_count, 0) as events_ocurred_count,
	coalesce(g.group_created_count, 0) as group_created_count,
	coalesce(m.members_joined_group_count, 0) as members_joined_group_count,
	coalesce(r.members_rsvp_count, 0) as members_rsvp_count,
	{{ dbt_date.now() }} as loaded_at
from {{ ref('dim_calendar') }} as dc
left join events_created as ec
	on dc.calendar_date = ec.event_created_at
left join events_ocurred as eo
	on dc.calendar_date = eo.event_time
left join groups as g
	on dc.calendar_date = g.group_created_at
left join memberships as m
	on dc.calendar_date = m.joined_at
left join rsvp as r
	on dc.calendar_date = r.rsvp_at
