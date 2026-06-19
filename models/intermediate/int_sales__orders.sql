{{ config(materialized='view') }}


WITH ref_data AS (

    SELECT * FROM {{ ref('stg_sales__orders') }}
  

)
,
refined_data as (
    select 
    transaction_id,
    TO_TIMESTAMP_NTZ(transaction_date, 'DD/MM/YYYY HH24:MI') AS transaction_date,
    store_location,
    SPLIT_PART(full_name, ' ', 1)   AS first_name,  
    SPLIT_PART(full_name, ' ', 2)   AS last_name,
    total_amount,
    payment_method,
    card_number,
    load_datetime,
    TRIM(item.value::VARCHAR)                       AS raw_item,
            item.index + 1                          AS item_sequence

    from ref_data,
    LATERAL FLATTEN(
            INPUT => SPLIT(product_and_price, ',')
        ) AS item
)
select 
    transaction_id,
    transaction_date,
    store_location,
    first_name,  
    last_name,
    TRIM( ARRAY_TO_STRING(ARRAY_SLICE(SPLIT(raw_item, ' - '), 0,ARRAY_SIZE(SPLIT(raw_item, ' - ')) - 1), ' - ' ))::VARCHAR  AS product_name,
            -- price = always the last segment after ' - '
    TRIM(GET(SPLIT(raw_item, ' - '),ARRAY_SIZE(SPLIT(raw_item, ' - ')) - 1 ))::FLOAT  AS price,
    total_amount,
    payment_method,
    card_number,
    load_datetime
from refined_data