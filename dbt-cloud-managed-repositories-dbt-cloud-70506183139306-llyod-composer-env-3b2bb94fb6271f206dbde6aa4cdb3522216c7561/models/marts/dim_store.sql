{{ config(alias='dim_store',
materialized='table') }}


WITH store_info AS (

    SELECT * FROM {{ ref('int_sales__orders') }}
  

)
, refined_store as (
select distinct store_location
from store_info
)
select 
    row_number() over ( order by store_location) as store_id,
    store_location as store_name,  
from refined_store
