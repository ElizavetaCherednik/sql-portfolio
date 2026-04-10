SELECT date_part('isodow', time)::int as weekday_number,
       to_char(time, 'Dy') as weekday,
       count(order_id) filter (WHERE action = 'create_order') as created_orders,
       count(order_id) filter (WHERE action = 'cancel_order') as canceled_orders,
       count(order_id) filter (WHERE action = 'create_order') - count(order_id) filter (WHERE action = 'cancel_order') as actual_orders,
       round((count(order_id) filter (WHERE action = 'create_order') - count(order_id) filter (WHERE action = 'cancel_order'))::decimal / count(order_id) filter (WHERE action = 'create_order'),
             3) as success_rate
FROM   user_actions
WHERE  time >= '2022-08-24'
   and time < '2022-09-07'
GROUP BY weekday_number, weekday
ORDER BY weekday_number
