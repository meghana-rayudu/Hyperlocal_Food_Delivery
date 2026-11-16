import { NextResponse } from "next/server";
import { pool } from "@/lib/mysql";

export const dynamic = "force-dynamic";

export async function GET() {
  try {
    const [[metrics]]: any = await pool.query(`
      SELECT
        (SELECT COUNT(*) FROM orders) AS orders,
        (SELECT COALESCE(SUM(total_amount),0) FROM orders) AS revenue,
        (SELECT COUNT(*) FROM delivery WHERE status IN ('ASSIGNED','PICKED_UP','IN_TRANSIT')) AS activeDeliveries,
        (SELECT COUNT(*) FROM courier WHERE status='AVAILABLE') AS availableCouriers
    `);
    const [recentOrders]: any = await pool.query("SELECT * FROM order_summary ORDER BY order_time DESC LIMIT 10");
    return NextResponse.json({ metrics, recentOrders });
  } catch (error) {
    console.error(error);
    return NextResponse.json({ error: "Unable to read dashboard data. Verify MySQL setup and environment variables." }, { status: 500 });
  }
}
