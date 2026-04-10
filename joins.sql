WITH order_id_large_size  AS (
    SELECT order_id
    FROM orders
    WHERE array_length(product_ids, 1) = (SELECT max(array_length(product_ids, 1)) FROM orders)
)

SELECT DISTINCT order_id, user_id, courier_id, 
    DATE_PART('year', AGE((SELECT max(time) FROM user_actions), users.birth_date))::integer AS user_age, 
    DATE_PART('year', AGE((SELECT max(time) FROM courier_actions), couriers.birth_date))::integer AS courier_age 
FROM (SELECT user_id, order_id
        FROM user_actions  
        WHERE order_id in (SELECT * FROM order_id_large_size)) t1
    LEFT JOIN (SELECT courier_id, order_id
        FROM courier_actions
        WHERE order_id in (SELECT *
                                   FROM   order_id_large_size)) t2 using(order_id)
    LEFT JOIN users using(user_id)
    LEFT JOIN couriers using(courier_id)
ORDER BY order_id
