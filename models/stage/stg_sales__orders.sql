
{{ config(materialized='view') }}




select
        transaction_id,
        transaction_date,
        store_ocation::varchar     AS store_location,
        full_name::varchar         AS full_name,
        product_and_price::varchar  AS product_and_price,
        total_amount::float         AS total_amount,
        payment_method::varchar     AS payment_method,
        card_number::varchar        AS card_number,
        loaded_at as load_datetime
from {{ source('sales', 'customer_sales') }}





