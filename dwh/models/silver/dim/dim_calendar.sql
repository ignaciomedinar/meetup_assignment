with dates_max_min as (
	select
		min(event_created_at)::date as min_date,
		max(event_created_at)::date as max_date
	from {{ ref('dim_events') }}

	union all

	select
		min(event_time)::date as min_date,
		max(event_time)::date as max_date
	from {{ ref('fact_events') }}

	union all

	select
		min(group_created_at)::date as min_date,
		max(group_created_at)::date as max_date
	from {{ ref('dim_groups') }}

	union all

	select
		min(joined_at)::date as min_date,
		max(joined_at)::date as max_date
	from {{ ref('fact_memberships') }}

	union all

	select
		min(rsvp_at)::date as min_date,
		max(rsvp_at)::date as max_date
	from {{ ref('fact_rsvp') }}

),

date_range as (
	select explode(sequence(
		(select min(min_date) from dates_max_min),
		(select max(max_date) from dates_max_min),
  --   last_day(trunc(current_date(), 'YEAR') + interval 11 months),
		interval 1 day
	)) as date
)

select
	date_format(date, 'yyyyMMdd')::int as date_key,
	date as calendar_date,
	date_trunc('MONTH', date)::date as month_start,
	date_trunc('WEEK', date)::date as week_start,
	year(date) as year,
	month(date) as month,
	day(date) as day,
	date_format(date, 'MMMM') as month_name,
	date_format(date, 'E') as weekday_name,
	dayofweek(date) as weekday_number,
	weekofyear(date) as week_of_year,
	quarter(date) as quarter,
	coalesce(dayofweek(date) in (1, 7), false) as is_weekend
from date_range
order by calendar_date
