select distinct
	group_id,
	name as group_name,
	from_unixtime(created / 1000)::timestamp as group_created_at,
	city as group_city,
	lat as group_lat,
	lon as group_lon,
	link as group_link,
	regexp_replace(description, '<[^>]*>', '') as group_description,
	concat_ws(' | ', regexp_extract_all(description, 'href="([^"]+)"')) as group_urls,
	{{ dbt_date.now() }} as loaded_at
from {{ ref('raw_groups') }}
