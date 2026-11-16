import { NextRequest, NextResponse } from "next/server";
import { pool } from "@/lib/mysql";
export async function GET(request: NextRequest) {
  const courierId = Number(request.nextUrl.searchParams.get("courierId"));
  if (!Number.isInteger(courierId)) return NextResponse.json({ error: "courierId is required" }, { status: 400 });
  try {
    const [rows]: any = await pool.query(`SELECT d.delivery_id, d.status AS delivery_status, d.courier_id,
      o.order_id, o.status AS order_status, o.total_amount, r.name AS restaurant_name, r.area AS restaurant_area,
      cu.name AS customer_name, cu.phone AS customer_phone, a.address_line, a.area AS customer_area
      FROM delivery d JOIN orders o ON o.order_id=d.order_id JOIN restaurant r ON r.restaurant_id=o.restaurant_id
      JOIN customer cu ON cu.customer_id=o.customer_id JOIN address a ON a.address_id=o.address_id
      WHERE d.status='UNASSIGNED' OR d.courier_id=? ORDER BY d.delivery_id DESC`, [courierId]);
    return NextResponse.json(rows);
  } catch { return NextResponse.json({ error: "Could not load delivery requests" }, { status: 500 }); }
}
