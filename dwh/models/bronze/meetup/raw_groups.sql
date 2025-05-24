select
	*,
	{{ dbt_date.now() }} as loaded_at
from {{ source('staging', 'stg_groups') }}
