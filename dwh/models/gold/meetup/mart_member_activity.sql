with base as (
	select
		du.user_id,
		user_city,
		user_country,
		user_hometown,
		min(fr.rsvp_at)::date as first_rsvp,
		max(fr.rsvp_at)::date as last_rsvp,
		count(distinct dg.group_id) as groups_count,
		count(distinct case when fr.response = 'yes' then fr.event_id else 0 end) as events_rsvp_count
	from {{ ref('dim_users') }} as du
	left join {{ ref('fact_memberships') }} as fm
		on du.user_id = fm.user_id
	left join {{ ref('dim_groups') }} as dg
		on fm.group_id = dg.group_id
	left join {{ ref('fact_rsvp') }} as fr
		on du.user_id = fr.user_id
	group by
		du.user_id,
		user_city,
		user_country,
		user_hometown
)

select
	*,
	{{ dbt_date.now() }} as loaded_at
from base
