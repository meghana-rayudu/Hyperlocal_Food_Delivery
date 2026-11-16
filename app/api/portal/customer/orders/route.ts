import { NextRequest, NextResponse } from "next/server";
import { pool } from "@/lib/mysql";
import { getMongoDb } from "@/lib/mongodb";
export async function GET(request: NextRequest) {
  const customerId = Number(request.nextUrl.searchParams.get("customerId"));
  if (!Number.isInteger(customerId)) return NextResponse.json({ error: "customerId is required" }, { status: 400 });
  try {
    const [rows]: any = await pool.query(`SELECT o.order_id, o.status AS order_status, o.total_amount, o.order_time,
      r.name AS restaurant_name, d.delivery_id, d.status AS delivery_status, c.name AS courier_name, c.phone AS courier_phone
      FROM orders o JOIN restaurant r ON r.restaurant_id=o.restaurant_id
      LEFT JOIN delivery d ON d.order_id=o.order_id LEFT JOIN courier c ON c.courier_id=d.courier_id
      WHERE o.customer_id=? ORDER BY o.order_time DESC`, [customerId]);
    return NextResponse.json(rows);
  } catch { return NextResponse.json({ error: "Could not load customer orders" }, { status: 500 }); }
}
