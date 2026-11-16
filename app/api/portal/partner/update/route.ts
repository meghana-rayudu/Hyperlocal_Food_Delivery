import { NextRequest, NextResponse } from "next/server";
import { pool } from "@/lib/mysql";
import { getMongoDb } from "@/lib/mongodb";
const nextStep: Record<string, string> = { ACCEPT: "ASSIGNED", PICKUP: "PICKED_UP", START: "IN_TRANSIT", COMPLETE: "DELIVERED" };
export async function POST(request: NextRequest) {
  const body = await request.json();
  const courierId = Number(body.courierId), deliveryId = Number(body.deliveryId), action = String(body.action || "");
  if (!Number.isInteger(courierId) || !Number.isInteger(deliveryId) || !nextStep[action]) return NextResponse.json({ error: "Invalid delivery update." }, { status: 400 });
  const connection = await pool.getConnection();
  let event: any = null;
  try {
    await connection.beginTransaction();
    const [found]: any = await connection.query("SELECT delivery_id, order_id, courier_id, status FROM delivery WHERE delivery_id=? FOR UPDATE", [deliveryId]);
    if (!found.length) throw new Error("Delivery not found.");
    const d = found[0];
    if (action === "ACCEPT") {
      if (d.status !== "UNASSIGNED") throw new Error("This delivery has already been accepted.");
      const [partner]: any = await connection.query("SELECT status FROM courier WHERE courier_id=? FOR UPDATE", [courierId]);
      if (!partner.length || partner[0].status !== "AVAILABLE") throw new Error("This partner is not currently available to accept another delivery.");
      await connection.query("UPDATE delivery SET courier_id=?, assigned_at=NOW(), status='ASSIGNED' WHERE delivery_id=? AND status='UNASSIGNED'", [courierId, deliveryId]);
      await connection.query("UPDATE courier SET status='BUSY' WHERE courier_id=?", [courierId]);
    } else {
      if (Number(d.courier_id) !== courierId) throw new Error("This delivery belongs to another partner.");
      const expected: Record<string,string> = { PICKUP: "ASSIGNED", START: "PICKED_UP", COMPLETE: "IN_TRANSIT" };
      if (d.status !== expected[action]) throw new Error("Complete the previous delivery step first.");
      if (action === "PICKUP") await connection.query("UPDATE delivery SET status='PICKED_UP', picked_at=NOW() WHERE delivery_id=?", [deliveryId]);
      if (action === "START") await connection.query("UPDATE delivery SET status='IN_TRANSIT' WHERE delivery_id=?", [deliveryId]);
      if (action === "COMPLETE") {
        await connection.query("UPDATE delivery SET status='DELIVERED', delivered_at=NOW() WHERE delivery_id=?", [deliveryId]);
        await connection.query("UPDATE courier SET status='AVAILABLE' WHERE courier_id=?", [courierId]);
      }
    }
    const orderStatus = action === "COMPLETE" ? "DELIVERED" : action === "START" ? "OUT_FOR_DELIVERY" : action === "PICKUP" ? "READY" : null;
    if (orderStatus) await connection.query("UPDATE orders SET status=? WHERE order_id=?", [orderStatus, d.order_id]);
    event = { delivery_id: deliveryId, order_id: d.order_id, courier_id: courierId, event_type: action === "ACCEPT" ? "COURIER_ASSIGNED" : action === "PICKUP" ? "ORDER_PICKED_UP" : action === "START" ? "OUT_FOR_DELIVERY" : "DELIVERED", created_at: new Date() };
    await connection.commit();
    try { await (await getMongoDb()).collection("delivery_events").insertOne(event); } catch (e) { console.warn("MongoDB event logging skipped:", e); }
    return NextResponse.json({ message: "Delivery updated", status: nextStep[action] });
  } catch (error) {
    await connection.rollback();
    return NextResponse.json({ error: error instanceof Error ? error.message : "Could not update delivery" }, { status: 400 });
  } finally { connection.release(); }
}
