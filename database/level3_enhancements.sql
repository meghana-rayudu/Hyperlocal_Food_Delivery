USE hyperlocal_food_delivery;

-- Audit table used by the order status trigger.
CREATE TABLE IF NOT EXISTS order_status_audit (
  audit_id BIGINT PRIMARY KEY AUTO_INCREMENT,
  order_id INT NOT NULL,
  old_status VARCHAR(30) NOT NULL,
  new_status VARCHAR(30) NOT NULL,
  changed_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_audit_order FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE
);

-- Drop and recreate trigger/procedure safely for repeatable setup.
DROP TRIGGER IF EXISTS trg_order_status_audit;
DELIMITER $$
CREATE TRIGGER trg_order_status_audit
AFTER UPDATE ON orders
FOR EACH ROW
BEGIN
  IF OLD.status <> NEW.status THEN
    INSERT INTO order_status_audit(order_id, old_status, new_status)
    VALUES (NEW.order_id, OLD.status, NEW.status);
  END IF;
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_update_order_status;
DELIMITER $$
CREATE PROCEDURE sp_update_order_status(IN p_order_id INT, IN p_new_status VARCHAR(30))
BEGIN
  IF p_new_status NOT IN ('PLACED','CONFIRMED','PREPARING','READY','OUT_FOR_DELIVERY','DELIVERED','CANCELLED') THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid order status';
  END IF;
  UPDATE orders SET status = p_new_status WHERE order_id = p_order_id;
  IF ROW_COUNT() = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Order not found or status unchanged';
  END IF;
END$$
DELIMITER ;

-- Additional indexes (the original dump already defines several useful indexes).
CREATE INDEX idx_orders_order_time ON orders(order_time);
CREATE INDEX idx_delivery_status ON delivery(status);
CREATE INDEX idx_payment_status ON payment(status);
CREATE INDEX idx_menu_item_name ON menu_item(name);

-- Full-text search for restaurant menu discovery.
ALTER TABLE menu_item ADD FULLTEXT INDEX ft_menu_name_description(name, description);

-- Example: CALL sp_update_order_status(5, 'CONFIRMED');
-- Example: UPDATE orders SET status='PREPARING' WHERE order_id=5;
-- The trigger records the old and new status in order_status_audit.
