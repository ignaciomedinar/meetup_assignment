{{
    config(
        unique_key ='event_name',
        materialized = 'incremental'
    )
}}

with events as (
	select distinct
		name as event_name,
		created
	from {{ ref('raw_events') }}
),

max_created as (
	select max(event_created_at) as max_created
	from {{ this }}
)

select
{% if is_incremental() %}
		row_number() over (
			order by created
		) + (select max(event_id) from {{ this }}) as event_id,
		event_name,
		from_unixtime(created / 1000)::timestamp as event_created_at,
		{{ dbt_date.now() }} as loaded_at
{% else %}  
        row_number() over (order by created) AS event_id,
        event_name,
        from_unixtime(created / 1000)::timestamp as event_created_at,
        {{ dbt_date.now() }} as loaded_at
    {% endif %}  

from events

{% if is_incremental() %}
	where from_unixtime(created / 1000)::timestamp > (select max_created from max_created)
{% endif %}
