const db = db.getSiblingDB("hyperlocal_food_delivery_nosql");

db.delivery_events.createIndex({ orderId: 1, occurredAt: -1 });
db.delivery_events.createIndex({ deliveryId: 1, eventType: 1 });
db.search_activity.createIndex({ searchedAt: -1 });

db.delivery_events.insertMany([
  { orderId: 1, deliveryId: 1, courierId: 1, eventType: "ORDER_PICKED_UP", note: "Courier picked up the order", location: { area: "Indiranagar", lat: 12.9719, lng: 77.6412 }, occurredAt: ISODate("2026-08-24T12:25:00Z") },
  { orderId: 1, deliveryId: 1, courierId: 1, eventType: "OUT_FOR_DELIVERY", note: "Order is on the way", location: { area: "Indiranagar", lat: 12.9718, lng: 77.6410 }, occurredAt: ISODate("2026-08-24T12:35:00Z") },
  { orderId: 1, deliveryId: 1, courierId: 1, eventType: "DELIVERED", note: "Order delivered", location: { area: "Indiranagar", lat: 12.9716, lng: 77.6412 }, occurredAt: ISODate("2026-08-24T12:50:00Z") },
  { orderId: 2, deliveryId: 2, courierId: 2, eventType: "ORDER_PICKED_UP", note: "Order picked up", location: { area: "Koramangala", lat: 12.9352, lng: 77.6245 }, occurredAt: ISODate("2026-08-24T13:20:00Z") }
]);

db.search_activity.insertMany([
  { searchTerm: "biryani", filters: { area: "Indiranagar", category: "Main Course" }, resultCount: 3, searchedAt: new Date() },
  { searchTerm: "healthy bowl", filters: { area: "Richmond Town" }, resultCount: 2, searchedAt: new Date() }
]);

print("MongoDB sample collections and indexes created.");
