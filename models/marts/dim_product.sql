{{ config(alias='dim_product',
materialized='table') }}


WITH product_info AS (

    SELECT distinct product_name
    
    FROM {{ ref('int_sales__orders') }}
  

)
select
    row_number() over(order by product_name) as product_id,
    TRIM(SPLIT_PART(product_name, '-', 1)) AS name_of_product,
    TRIM(SPLIT_PART(product_name, '-', 2)) AS flavour
from product_info

