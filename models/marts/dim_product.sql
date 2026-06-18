{{ config(alias='dim_product',
materialized='table') }}


WITH product_info AS (

    SELECT distinct product_name
    
    FROM {{ ref('int_sales__orders') }}
  

)
select
    row_number() over(order by product_name) as product_id,
    product_name

from product_info

