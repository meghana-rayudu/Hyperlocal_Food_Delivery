# Data dictionary

| Table | Purpose | Primary key | Important foreign keys |
|---|---|---|---|
| customer | Customer account profile | customer_id | — |
| address | Customer delivery addresses | address_id | customer_id → customer |
| restaurant | Restaurant details and location | restaurant_id | — |
| menu_item | Restaurant menu and prices | item_id | restaurant_id → restaurant |
| orders | Customer order header | order_id | customer_id, restaurant_id, address_id |
| order_item | Items and quantities within an order | (order_id, item_id) | order_id → orders; item_id → menu_item |
| courier | Delivery personnel and availability | courier_id | — |
| delivery | Courier assignment and delivery lifecycle | delivery_id | order_id → orders; courier_id → courier |
| payment | Payment information for an order | payment_id | order_id → orders |
| delivery_allocation | Candidate courier scores and selection result | allocation_id | delivery_id → delivery; courier_id → courier |
| order_status_audit | History of order status changes | audit_id | order_id → orders |

## MongoDB collections

### delivery_events
Example document:
```json
{
  "orderId": 1,
  "deliveryId": 1,
  "courierId": 1,
  "eventType": "DELIVERED",
  "note": "Order delivered",
  "location": { "area": "Indiranagar", "lat": 12.9716, "lng": 77.6412 },
  "occurredAt": "2026-08-24T12:50:00.000Z"
}
```

### search_activity
Stores a search term, arbitrary filters, result count and timestamp. The flexible `filters` object can contain area, category, price range or other future search criteria.
