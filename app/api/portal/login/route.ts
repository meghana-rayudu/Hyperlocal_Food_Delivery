import { NextRequest, NextResponse } from "next/server";
import { pool } from "@/lib/mysql";

// Academic demo login: selects an existing seeded customer or courier.
// Replace with password verification and signed sessions before production use.
export async function POST(request: NextRequest) {
  try {
    const { role, id } = await request.json();
    const accountId = Number(id);
    if (!Number.isInteger(accountId) || accountId < 1) return NextResponse.json({ error: "Choose a valid demo account." }, { status: 400 });
    if (role === "CUSTOMER") {
      const [rows]: any = await pool.query("SELECT customer_id AS id, name, email FROM customer WHERE customer_id=?", [accountId]);
      if (!rows.length) return NextResponse.json({ error: "Customer account not found." }, { status: 404 });
      return NextResponse.json({ ...rows[0], role: "CUSTOMER" });
    }
    if (role === "PARTNER") {
      const [rows]: any = await pool.query("SELECT courier_id AS id, name, phone, vehicle_type, status FROM courier WHERE courier_id=?", [accountId]);
      if (!rows.length) return NextResponse.json({ error: "Delivery partner not found." }, { status: 404 });
      return NextResponse.json({ ...rows[0], role: "PARTNER" });
    }
    return NextResponse.json({ error: "Choose Customer or Delivery Partner." }, { status: 400 });
  } catch (error) {
    console.error("Portal login database error:", error);
    const message = error instanceof Error ? error.message : "Unknown database error";
    return NextResponse.json({ error: `Login database error: ${message}` }, { status: 500 });
  }
}
