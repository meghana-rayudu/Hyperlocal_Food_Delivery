# Portal demo walkthrough

1. Start MySQL and MongoDB services.
2. Configure `.env.local` using `.env.example` and keep `npm run dev` running.
3. Open `http://localhost:3000`.
4. Choose **Customer**, select Rahul Sharma, and continue. The customer page shows seeded orders and delivery progress.
5. Open a private/incognito browser window or log out. Choose **Delivery partner**, select Ravi Kumar, and continue.
6. The partner page shows unassigned delivery requests and requests assigned to Ravi. Accept an unassigned request, then progress it through **Mark picked up**, **Start delivery**, and **Mark delivered**.
7. Return to the customer page. It refreshes automatically and displays the updated status and partner information.
8. Visit `/admin` for the original operations dashboard and `/api/events/summary` for the MongoDB event aggregation.

## Notes
- Use a delivery row whose status is `UNASSIGNED` for the accept demonstration.
- A partner must complete the current delivery before accepting another if the seeded courier status is BUSY.
- Demo login is account selection only, not secure authentication.
- Courier location is not live GPS. The application demonstrates status-based delivery progress.
