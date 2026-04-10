SELECT
    DATE_PART('isodow', time)::int AS weekday_number,
    TO_CHAR(time, 'Dy') AS weekday,
    COUNT(DISTINCT order_id) FILTER (WHERE action = 'create_order') AS created_orders,
    COUNT(DISTINCT order_id) FILTER (WHERE action = 'cancel_order') AS canceled_orders,
    COUNT(DISTINCT order_id)  FILTER (WHERE action = 'create_order') - COUNT(DISTINCT order_id) FILTER (WHERE action = 'cancel_order') AS actual_orders,
    ROUND(
        (COUNT(DISTINCT order_id) FILTER (WHERE action = 'create_order') - COUNT(DISTINCT order_id) FILTER (WHERE action = 'cancel_order'))::decimal / 
        COUNT(DISTINCT order_id) FILTER (WHERE action = 'create_order'),
        3
    ) AS success_rate
FROM user_actions
WHERE time BETWEEN '2022-08-24' AND '2022-09-06 23:59:59'
GROUP BY weekday_number, weekday
ORDER BY weekday_number
