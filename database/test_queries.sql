USE hyperlocal_food_delivery;

-- 1. SELECT + JOIN: order details.
SELECT o.order_id, c.name AS customer, r.name AS restaurant, o.status, o.total_amount
FROM orders o
JOIN customer c ON c.customer_id = o.customer_id
JOIN restaurant r ON r.restaurant_id = o.restaurant_id
ORDER BY o.order_time DESC;

-- 2. GROUP BY + aggregate: revenue by restaurant.
SELECT r.name, COUNT(o.order_id) AS order_count, SUM(o.total_amount) AS revenue
FROM restaurant r
LEFT JOIN orders o ON o.restaurant_id = r.restaurant_id
GROUP BY r.restaurant_id, r.name
ORDER BY revenue DESC;

-- 3. HAVING: restaurants with at least one order.
SELECT r.name, COUNT(o.order_id) AS order_count
FROM restaurant r JOIN orders o ON o.restaurant_id = r.restaurant_id
GROUP BY r.restaurant_id, r.name
HAVING COUNT(o.order_id) >= 1;

-- 4. Subquery: menu items priced above the average menu price.
SELECT name, price FROM menu_item
WHERE price > (SELECT AVG(price) FROM menu_item)
ORDER BY price DESC;

-- 5. View: order summary.
SELECT * FROM order_summary ORDER BY order_time DESC;

-- 6. View: courier delivery summary.
SELECT * FROM courier_delivery_summary ORDER BY total_deliveries DESC;

-- 7. Full-text menu search.
SELECT item_id, name, description
FROM menu_item
WHERE MATCH(name, description) AGAINST ('paneer' IN NATURAL LANGUAGE MODE);

-- 8. Stored procedure and trigger demonstration.
-- CALL sp_update_order_status(5, 'CONFIRMED');
-- SELECT * FROM order_status_audit ORDER BY changed_at DESC;

-- 9. Transaction demonstration. Run as a single session.
START TRANSACTION;
UPDATE courier SET status='BUSY' WHERE courier_id=1 AND status='AVAILABLE';
-- Inspect before commit in a separate query if desired.
ROLLBACK;
