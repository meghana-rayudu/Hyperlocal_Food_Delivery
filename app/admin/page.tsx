"use client";

import { useEffect, useState } from "react";

type Dashboard = {
  metrics: { orders: number; revenue: number; activeDeliveries: number; availableCouriers: number };
  recentOrders: Array<{ order_id: number; customer_name: string; restaurant_name: string; status: string; total_amount: number }>;
};

export default function Home() {
  const [data, setData] = useState<Dashboard | null>(null);
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(true);

  async function load() {
    setLoading(true);
    setError("");
    try {
      const response = await fetch("/api/dashboard", { cache: "no-store" });
      const result = await response.json();
      if (!response.ok) throw new Error(result.error || "Could not load dashboard");
      setData(result);
    } catch (e) {
      setError(e instanceof Error ? e.message : "Unexpected error");
    } finally {
      setLoading(false);
    }
  }

  useEffect(() => { load(); }, []);

  return (
    <main>
      <header>
        <div>
          <h1>Hyperlocal Food Delivery</h1>
          <div className="subtitle">Operations dashboard · Real-time courier allocation</div>
        </div>
        <span className="pill">LEVEL 3 PROJECT</span>
      </header>

      {error && <div className="panel error">{error}<p className="notice">Check that MySQL is running, the SQL scripts have been imported, and `.env.local` is configured.</p></div>}
      {loading && <div className="panel">Loading dashboard data…</div>}

      {data && <>
        <section className="cards">
          <div className="card"><small>Total orders</small><div className="metric">{data.metrics.orders}</div></div>
          <div className="card"><small>Total order value</small><div className="metric">₹{Number(data.metrics.revenue).toLocaleString("en-IN")}</div></div>
          <div className="card"><small>Active deliveries</small><div className="metric">{data.metrics.activeDeliveries}</div></div>
          <div className="card"><small>Available couriers</small><div className="metric">{data.metrics.availableCouriers}</div></div>
        </section>

        <section className="panel">
          <h2>Recent orders</h2>
          <table>
            <thead><tr><th>Order</th><th>Customer</th><th>Restaurant</th><th>Status</th><th>Amount</th></tr></thead>
            <tbody>
              {data.recentOrders.map(order => <tr key={order.order_id}>
                <td>#{order.order_id}</td><td>{order.customer_name}</td><td>{order.restaurant_name}</td>
                <td><span className="status">{order.status.replaceAll("_", " ")}</span></td>
                <td>₹{Number(order.total_amount).toFixed(2)}</td>
              </tr>)}
            </tbody>
          </table>
          {data.recentOrders.length === 0 && <p className="notice">No orders found. Import the sample SQL data to populate this table.</p>}
        </section>
      </>}

      <div className="actions">
        <button onClick={load}>Refresh dashboard</button>
        <button className="secondary" onClick={() => window.location.href="/api/events/summary"}>View NoSQL event summary</button>
      </div>
      <p className="notice">MySQL stores structured transactional data. MongoDB stores flexible delivery-event documents and supports event aggregation.</p>
    </main>
  );
}
