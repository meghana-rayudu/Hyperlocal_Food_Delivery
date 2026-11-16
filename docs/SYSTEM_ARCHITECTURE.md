# System architecture

```text
Customer / Admin browser
          |
          v
     Next.js UI
          |
          v
 Next.js Route Handlers (API)
       /             \
      v               v
   MySQL            MongoDB
 structured data   flexible event data
      |               |
 orders, users,      delivery_events,
 menu, courier,      search_activity
 payment, allocation
```

## Data ownership
- MySQL is authoritative for orders, payments, customers, restaurants, menu items, courier availability and delivery assignments.
- MongoDB stores event history and search activity. It does not replace the relational order record.

## Request flow: order creation
1. Client submits customer, restaurant, address and item identifiers/quantities.
2. API validates required fields.
3. API starts a MySQL transaction.
4. API verifies menu item availability and reads current prices.
5. API inserts the order and its order-item rows.
6. API commits only if all inserts succeed; otherwise it rolls back.

## Request flow: courier allocation
1. API locks the target unassigned delivery.
2. API reads available couriers.
3. API calculates a demonstration score for each candidate.
4. API records all candidate results in `delivery_allocation`.
5. API assigns the highest-ranked courier and updates courier availability in the same transaction.

## Security and configuration
Database connection values and JWT secret are loaded from `.env.local`. The file is excluded from Git using `.gitignore`. Add production authentication, authorization middleware, rate limiting and request validation before deployment.
