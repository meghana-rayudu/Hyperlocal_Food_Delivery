# Hyperlocal Food Delivery & Real-Time Courier Allocation System

**DBMS Level 3 project**  
Team: Priyanka N (PES2UG24CS379), Rayudu Meghana (PES2UG24CS398)

This package contains the existing MySQL project database, a Next.js web application starter integrated with MySQL and MongoDB, database enhancements for Level 3 concepts, documentation, and setup instructions.

## Technology stack
- Frontend and API: Next.js (App Router), TypeScript
- Relational database: MySQL 8+
- NoSQL database: MongoDB
- Data access: `mysql2/promise`, MongoDB Node.js driver
- Authentication utilities: `bcryptjs`, `jsonwebtoken`

## Folder structure
```text
Hyperlocal_Food_Delivery_Level3/
├── app/                         # Next.js UI and API routes
├── components/                  # Reusable UI components
├── lib/                         # MySQL, MongoDB and shared helpers
├── database/
│   ├── hyperlocal_food_delivery.sql   # Original database export
│   ├── level3_enhancements.sql        # Triggers, procedure, indexes, etc.
│   ├── nosql_seed.js                  # MongoDB sample documents
│   └── test_queries.sql              # Demonstration queries
├── docs/
│   ├── PROJECT_REPORT.md
│   ├── SYSTEM_ARCHITECTURE.md
│   ├── DATA_DICTIONARY.md
│   ├── TEST_CASES.md
│   └── ER_DIAGRAM.mmd
├── .env.example
├── package.json
└── README.md
```

## Prerequisites
1. Node.js 20 or later and npm.
2. MySQL 8.0 or later.
3. MongoDB Community Server or a MongoDB Atlas database.
4. Git (recommended).

## 1. Set up MySQL
Open MySQL Workbench or the MySQL command line and run the original database script:

```bash
mysql -u root -p < database/hyperlocal_food_delivery.sql
```

Then apply the Level 3 enhancements:

```bash
mysql -u root -p < database/level3_enhancements.sql
```

The original dump contains sample customers, restaurants, menu items, orders, couriers, deliveries, allocation records and payments. Sample customer password values in the dump are placeholders, not usable login credentials.

## 2. Set up MongoDB
Create a database named `hyperlocal_food_delivery_nosql`. Run:

```bash
mongosh "<your MongoDB connection string>" database/nosql_seed.js
```

The NoSQL component stores delivery event history and search activity as flexible documents. It complements MySQL, which remains the source of truth for orders, payments, customers, restaurants and courier assignments.

## 3. Configure the application
Copy `.env.example` to `.env.local` and fill in your own local credentials:

```env
MYSQL_HOST=localhost
MYSQL_PORT=3306
MYSQL_USER=root
MYSQL_PASSWORD=your_mysql_password
MYSQL_DATABASE=hyperlocal_food_delivery
MONGODB_URI=mongodb://127.0.0.1:27017
MONGODB_DB=hyperlocal_food_delivery_nosql
JWT_SECRET=replace_with_a_long_random_secret
```

Never commit `.env.local` or real credentials to GitHub.

## 4. Install and run
```bash
npm install
npm run dev
```
Open http://localhost:3000.

## Application features included
- Dashboard cards for orders, revenue, active deliveries and available couriers.
- Recent orders table backed by MySQL.
- Create-order API using a MySQL transaction.
- Courier allocation API that ranks available couriers using distance and estimated time, then records the decision in `delivery_allocation`.
- MongoDB API endpoint for recording and retrieving delivery events.
- MongoDB aggregation endpoint for event counts by type.
- Environment-based database configuration.

## API routes
| Method | Route | Purpose |
|---|---|---|
| GET | `/api/dashboard` | Dashboard metrics and recent orders |
| GET, POST | `/api/orders` | List orders / create an order transactionally |
| POST | `/api/allocate` | Score available couriers and allocate the best candidate |
| GET, POST | `/api/events` | Read / record MongoDB delivery events |
| GET | `/api/events/summary` | MongoDB aggregation summary |

## Level 3 database concepts demonstrated
### SQL
- Primary keys, foreign keys, UNIQUE and CHECK constraints.
- Indexes for frequently filtered and joined columns.
- Views: `order_summary` and `courier_delivery_summary`.
- Stored procedure: `sp_update_order_status`.
- Trigger: records an order status change in an audit table.
- Transaction: order creation inserts an order and its items atomically.
- JOIN, GROUP BY, aggregate functions, subqueries and ORDER BY in `test_queries.sql`.

### NoSQL
- MongoDB `delivery_events` collection for timestamped event documents.
- MongoDB `search_activity` collection for flexible search metadata.
- Indexes on delivery/order identifiers and event timestamps.
- Aggregation pipeline to summarize event types by order.

## Important notes before submission
- This is a runnable project scaffold, not a claim that it has been deployed on your machine.
- Configure both databases and run the SQL scripts before starting the app.
- Replace placeholder secrets and create your own authentication integration if your instructor expects a full login flow. The included `lib/auth.ts` provides password hashing and JWT helper functions, but the sample SQL dump does not contain real password hashes or user accounts.
- Add your own application screenshots after running the application. Do not submit screenshots of an app that you have not run.
- Review and personalize the report's team contribution section to accurately reflect the work each member completed.

## Customer and delivery-partner portals (demo)

The home page (`/`) now provides two demo entry points. Select a seeded customer or delivery partner to enter the corresponding portal.

- **Customer portal:** `/customer` displays the signed-in demo customer's orders, order progress, assigned courier name and contact number. It refreshes every five seconds.
- **Delivery-partner portal:** `/partner` lists unassigned requests and deliveries assigned to the selected courier. The partner can accept a request, mark it picked up, start delivery, and mark it delivered.
- **Operations dashboard:** `/admin` retains the original project dashboard.

The partner workflow updates the existing MySQL `delivery`, `orders`, and `courier` tables transactionally. It also attempts to append a document to MongoDB's `delivery_events` collection. If MongoDB is temporarily unavailable, the SQL delivery update still succeeds and the event write is logged as skipped.

### Demo accounts

Choose an account from the login page. Seeded customer accounts include Rahul Sharma, Ananya Rao, Arjun Kumar, Meera Nair and Arun Varma. Seeded delivery partners include Ravi Kumar, Suresh Babu, Nikhil Raj, Vikram Singh and Aman Joseph.

**Demo limitations:** This is a classroom demonstration login that selects existing seeded accounts; it is not production authentication. It does not implement real GPS tracking, payment processing, SMS, or push notifications. Customer progress is refreshed by polling the database every five seconds. Do not expose this demo login publicly or use it with real customer data.


## Troubleshooting portal login

After starting the app, open `http://localhost:3000/api/health`. It reports whether MySQL can connect to the configured database and whether MongoDB responds to ping. Portal login errors now return the underlying MySQL error in the response and log it in the terminal. Confirm `.env.local` is in the same folder as `package.json`, then restart `npm run dev` after editing it.
