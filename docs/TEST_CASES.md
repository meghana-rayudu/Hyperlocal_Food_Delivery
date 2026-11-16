# Test cases

| ID | Test | Steps | Expected result |
|---|---|---|---|
| TC01 | Database creation | Import `hyperlocal_food_delivery.sql` | Database and base tables are created |
| TC02 | Referential integrity | Insert an order with a non-existent customer | MySQL rejects the row |
| TC03 | Unique customer email | Insert duplicate customer email | MySQL rejects the row |
| TC04 | Menu price validation | Insert a menu item with price 0 | CHECK constraint rejects it |
| TC05 | Order summary view | Run `SELECT * FROM order_summary` | Joined order/customer/restaurant rows appear |
| TC06 | Courier summary view | Run `SELECT * FROM courier_delivery_summary` | Delivery count appears per courier |
| TC07 | Trigger audit | Change an order status | Old/new status appears in `order_status_audit` |
| TC08 | Stored procedure | Call `sp_update_order_status` with valid status | Order status updates |
| TC09 | Invalid status | Call procedure with invalid status | Procedure raises SQL error |
| TC10 | Transaction rollback | Run sample transaction then ROLLBACK | Change is not persisted |
| TC11 | Dashboard | Start Next.js with MySQL configured | Metrics and recent orders load |
| TC12 | MongoDB event insert | POST a valid event to `/api/events` | Event document is inserted |
| TC13 | MongoDB aggregation | Open `/api/events/summary` | Event counts grouped by event type appear |
| TC14 | Allocation | POST an unassigned delivery and location to `/api/allocate` | Candidate scores are recorded and top candidate assigned |

## Manual API examples

Create an event:
```bash
curl -X POST http://localhost:3000/api/events \
  -H "Content-Type: application/json" \
  -d '{"orderId":1,"deliveryId":1,"courierId":1,"eventType":"ARRIVED_AT_CUSTOMER","note":"Courier reached customer"}'
```

View event summary:
```bash
curl http://localhost:3000/api/events/summary
```

Allocate a courier (use an existing UNASSIGNED delivery ID):
```bash
curl -X POST http://localhost:3000/api/allocate \
  -H "Content-Type: application/json" \
  -d '{"deliveryId":3,"restaurantLat":12.9719,"restaurantLng":77.6412}'
```

Create an order (use existing customer, restaurant, address and menu IDs):
```bash
curl -X POST http://localhost:3000/api/orders \
  -H "Content-Type: application/json" \
  -d '{"customerId":1,"restaurantId":1,"addressId":1,"items":[{"itemId":1,"quantity":1}]}'
```
