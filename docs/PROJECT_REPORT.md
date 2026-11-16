# Hyperlocal Food Delivery & Real-Time Courier Allocation System

## 1. Abstract
The project models a hyperlocal food-delivery platform in which customers place orders with nearby restaurants and available couriers are selected for delivery. MySQL manages structured entities and transactional operations. MongoDB stores flexible delivery-event history and search activity, where event fields may evolve over time.

## 2. Problem statement
A local delivery platform must coordinate customers, saved addresses, restaurants, menu items, orders, payments and couriers. It must preserve transaction consistency while recording a changing sequence of delivery events. A basic CRUD-only system does not adequately demonstrate order processing, courier selection, auditability or event analytics.

## 3. Objectives
- Design a relational database for customers, addresses, restaurants, menu items, orders, order items, couriers, deliveries, payments and allocation decisions.
- Enforce referential integrity and data validation through keys and constraints.
- Demonstrate SQL DDL, DML, joins, aggregation, subqueries, views, indexes, stored procedures, triggers and transactions.
- Use MongoDB for flexible delivery event documents and search activity.
- Provide a Next.js web dashboard and API layer for database interaction.
- Demonstrate courier ranking and transactional order creation.

## 4. Functional requirements
1. Store customer and address information.
2. Maintain restaurant and menu-item details.
3. Create orders containing one or more menu items.
4. Track order and payment status.
5. Maintain courier availability and delivery status.
6. Compare available couriers using estimated distance, time and allocation score.
7. Store a history of delivery events in MongoDB.
8. Display order, revenue, delivery and courier metrics in a dashboard.

## 5. Database choice and justification
### MySQL
MySQL is used for data with strong relationships and transactional consistency: customers, addresses, restaurants, menu items, orders, payments, couriers and deliveries. Primary keys, foreign keys, unique constraints and transactions protect data integrity.

### MongoDB
MongoDB is used for delivery event history and search activity. Events can have optional location, notes, timestamps and additional metadata. A document model supports this evolving structure without repeatedly changing relational table definitions. MongoDB aggregation summarizes event types.

## 6. ER model and relational schema
The ER diagram source is in `ER_DIAGRAM.mmd`. The submitted project PDF contains the original hand-drawn ER diagram and relational schema on pages 1–2. The implemented SQL schema additionally includes `delivery_allocation` to record candidate courier scores.

Core relationships:
- CUSTOMER 1:M ADDRESS
- CUSTOMER 1:M ORDERS
- ADDRESS 1:M ORDERS
- RESTAURANT 1:M MENU_ITEM
- RESTAURANT 1:M ORDERS
- ORDERS 1:M ORDER_ITEM
- MENU_ITEM 1:M ORDER_ITEM
- ORDERS 1:1 DELIVERY
- COURIER 1:M DELIVERY
- ORDERS 1:1 PAYMENT
- DELIVERY 1:M DELIVERY_ALLOCATION
- COURIER 1:M DELIVERY_ALLOCATION

## 7. SQL implementation
The original database export is `database/hyperlocal_food_delivery.sql`. It creates and populates the relational schema. The Level 3 extension script is `database/level3_enhancements.sql`.

### Constraints and integrity
- Primary keys identify each entity.
- Foreign keys enforce valid relationships.
- UNIQUE constraints protect customer email/phone, courier phone, and one-to-one order payment/delivery relationships.
- CHECK constraints validate positive prices and quantities, non-negative amounts and valid allocation ranges.
- ENUM columns restrict status and category values.

### Advanced SQL concepts
1. **Transactions:** The order API inserts the order and all order items in one transaction. Failure rolls back the complete operation.
2. **Views:** `order_summary` joins orders, customers and restaurants. `courier_delivery_summary` reports delivery counts per courier.
3. **Stored procedure:** `sp_update_order_status` validates and updates order status.
4. **Trigger:** `trg_order_status_audit` records status changes in `order_status_audit`.
5. **Indexing:** Indexes support common filters and joins; a FULLTEXT index supports menu search.

## 8. NoSQL implementation
MongoDB database: `hyperlocal_food_delivery_nosql`.

Collections:
- `delivery_events`: order/delivery/courier references, event type, note, optional location object and event timestamp.
- `search_activity`: search term, flexible filter object, result count and timestamp.

Indexes:
- `{ orderId: 1, occurredAt: -1 }`
- `{ deliveryId: 1, eventType: 1 }`
- `{ searchedAt: -1 }`

Retrieval strategy:
- Query event history by order identifier, sorted newest-first.
- Aggregate event documents by `eventType`, counting events and finding the latest timestamp.

## 9. Application architecture
The browser uses the Next.js interface. Next.js Route Handlers act as the API layer. The API connects to MySQL for transactional and relational data and MongoDB for event documents. Credentials are read from environment variables rather than hard-coded.

## 10. Courier allocation logic
The allocation endpoint obtains available couriers, estimates distance and delivery time, calculates a bounded score, records each candidate as SELECTED or REJECTED, assigns the highest-scoring courier, and marks that courier BUSY. The current relational schema does not store live courier GPS coordinates, so the included endpoint uses a deterministic demonstration distance model. A production implementation should use live courier coordinates and a routing/distance service.

## 11. Testing
Test cases and expected outcomes are listed in `TEST_CASES.md`. Run the SQL test queries in `database/test_queries.sql` and verify the web dashboard after configuring both databases.

## 12. Team contributions
Update this section to reflect the actual work completed by each team member before submission.
- **Priyanka N (PES2UG24CS379):** [Add verified responsibilities and commits.]
- **Rayudu Meghana (PES2UG24CS398):** [Add verified responsibilities and commits.]

## 13. Conclusion
The project combines a relational transactional database with a document database for flexible event data. It demonstrates database design, integrity constraints, advanced SQL features, NoSQL aggregation, API integration and a web-based operational dashboard. The allocation module extends the database model beyond simple CRUD by recording and ranking courier candidates.
