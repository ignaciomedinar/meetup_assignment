{{
    config(
        unique_key= 'row_hash'
    )
}}

with base as (
    select
        de.event_id,
        name as event_name,
        status as event_status,
        rsvp_limit as event_rsvp_limit,
        from_unixtime(created / 1000)::timestamp as event_created_at,
        from_unixtime(time / 1000)::timestamp as event_time,
        case when duration is null then null else duration/60000 end as event_duration_minutes,
        venue_id,
        group_id,
        regexp_replace(description, '<[^>]*>', '') as event_description,
        concat_ws(' | ', regexp_extract_all(description, 'href="([^"]+)"')) AS event_urls,
        {{ dbt_utils.generate_surrogate_key(['de.event_id', 'name', 'status', 'rsvp_limit', 'created', 'time', 'duration', 'venue_id', 'group_id', 'description']) }} as row_hash,
        {{ dbt_date.now() }} as loaded_at
    from {{ ref('raw_events')}} re
    left join {{ ref('dim_events')}} as de
    on re.name=de.event_name
    and from_unixtime(re.created / 1000)::timestamp = de.event_created_at
)

select *
from base

{% if is_incremental() %}
    where row_hash not in (select row_hash from {{ this }})
{% endif %}
