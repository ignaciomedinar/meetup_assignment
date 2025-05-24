select distinct
	user_id,
	city as user_city,
	country as user_country,
	hometown as user_hometown,
	{{ dbt_date.now() }} as loaded_at
from {{ ref ('raw_users') }}
