WITH top_products as (SELECT product_id
                      FROM   products
                      ORDER BY price desc limit 5), unnest as (SELECT order_id,
                                                product_ids,
                                                unnest(product_ids) as product_id
                                         FROM   orders)
SELECT DISTINCT order_id,
                product_ids
FROM   unnest
WHERE  product_id in (SELECT product_id
                      FROM   top_products)
ORDER BY order_id
