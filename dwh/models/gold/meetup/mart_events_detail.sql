with base as (
	select
		fe.event_name,
		fe.event_status,
		fe.event_created_at::date as event_created_date,
		fe.event_time::date as event_date,
		{{ datediff("fe.event_created_at", "fe.event_time", "day") }} as created_to_event_days,
  --   date_diff(fe.event_time, fe.event_created_at) as days_to_event,
		fe.event_duration_minutes,
		dv.venue_name,
		dv.venue_city,
		dg.group_name,
		dg.group_city,
		case
			when group_lat = 0 or group_lon = 0 or venue_lat = 0 or venue_lon = 0 then NULL
			else
				round(6371 * acos(
					cos(radians(group_lat)) * cos(radians(venue_lat))
					* cos(radians(venue_lon) - radians(group_lon))
					+ sin(radians(group_lat)) * sin(radians(venue_lat))
				), 2)
		end as group_to_venue_km,
		count(distinct case when fr.response = 'yes' then fr.user_id else 0 end) as attendees_users,
		sum(case when fr.response = 'yes' then fr.guests else 0 end) as attendees_guests,
		attendees_users + attendees_guests as attendees_total
	from {{ ref('fact_events') }} as fe
	left join {{ ref('dim_venues') }} as dv
		on fe.venue_id = dv.venue_id
	left join {{ ref('dim_groups') }} as dg
		on fe.group_id = dg.group_id
	left join {{ ref('fact_rsvp') }} as fr
		on fe.event_id = fr.event_id
	group by
		fe.event_name,
		fe.event_status,
		event_created_date,
		event_date,
		created_to_event_days,
		fe.event_duration_minutes,
		dv.venue_name,
		dv.venue_city,
		dg.group_name,
		dg.group_city,
		group_to_venue_km
)

select
	*,
	{{ dbt_date.now() }} as loaded_at
from base
