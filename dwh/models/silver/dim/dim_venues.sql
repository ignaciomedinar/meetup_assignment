select distinct 
    venue_id,
    name,
    city,
    country,
    lat,
    lon
from {{ ref('raw_venues')}}
