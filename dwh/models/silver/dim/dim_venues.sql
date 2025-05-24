select distinct
	venue_id,
	name as venue_name,
	city as venue_city,
	country as venue_country,
	lat as venue_lat,
	lon as venue_lon,
	{{ dbt_date.now() }} as loaded_at
from {{ ref('raw_venues') }}
