with user_orders as (SELECT user_id,
                            order_id,
                            time,
                            row_number() OVER (PARTITION BY user_id
                                               ORDER BY time) as order_number,
                            lag(time, 1) OVER (PARTITION BY user_id
                                               ORDER BY time) as time_lag
                     FROM   user_actions
                     WHERE  order_id not in (SELECT order_id
                                             FROM   user_actions
                                             WHERE  action = 'cancel_order'))
SELECT user_id,
       order_id,
       time,
       order_number,
       time_lag,
       (time - time_lag) as time_diff
FROM   user_orders
ORDER BY user_id, order_number limit 1000
