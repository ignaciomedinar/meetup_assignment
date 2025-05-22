select distinct 
    user_id,
    city,
    country,
    hometown
from {{ ref ('raw_users')}}
