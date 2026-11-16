import { NextRequest, NextResponse } from "next/server";
import { pool } from "@/lib/mysql";

// Body: { deliveryId, restaurantLat, restaurantLng }
// Lower distance and estimated time produce a higher allocation score.
export async function POST(request: NextRequest) {
  const body = await request.json();
  const deliveryId = Number(body.deliveryId);
  const restaurantLat = Number(body.restaurantLat);
  const restaurantLng = Number(body.restaurantLng);
  if (!Number.isInteger(deliveryId) || !Number.isFinite(restaurantLat) || !Number.isFinite(restaurantLng)) {
    return NextResponse.json({ error: "Valid deliveryId, restaurantLat and restaurantLng are required." }, { status: 400 });
  }

  const connection = await pool.getConnection();
  try {
    await connection.beginTransaction();
    const [deliveryRows]: any = await connection.query(
      "SELECT delivery_id, status FROM delivery WHERE delivery_id=? FOR UPDATE", [deliveryId]
    );
    if (!deliveryRows.length) throw new Error("Delivery not found.");
    if (deliveryRows[0].status !== "UNASSIGNED") throw new Error("Only unassigned deliveries can be allocated.");

    const [couriers]: any = await connection.query(
      "SELECT courier_id, name FROM courier WHERE status='AVAILABLE' ORDER BY courier_id"
    );
    if (!couriers.length) throw new Error("No available courier.");

    const scored = couriers.map((c: any) => {
      // The current schema has no courier GPS fields. For this demo, use a stable
      // sample distance model; replace with live courier coordinates in deployment.
      const distance = 0.7 + ((Number(c.courier_id) * 37) % 19) / 10;
      const eta = Math.max(3, Math.ceil(distance * 4));
      const score = Math.max(0, Math.min(100, 100 - distance * 12 - eta * 2));
      return { ...c, distance, eta, score };
    }).sort((a: any, b: any) => b.score - a.score);

    const selected = scored[0];
    for (const candidate of scored) {
      await connection.query(
        "INSERT INTO delivery_allocation (delivery_id, courier_id, distance_km, estimated_time, allocation_score, result) VALUES (?, ?, ?, ?, ?, ?)",
        [deliveryId, candidate.courier_id, candidate.distance, candidate.eta, candidate.score, candidate.courier_id === selected.courier_id ? "SELECTED" : "REJECTED"]
      );
    }
    await connection.query(
      "UPDATE delivery SET courier_id=?, assigned_at=NOW(), status='ASSIGNED' WHERE delivery_id=?",
      [selected.courier_id, deliveryId]
    );
    await connection.query("UPDATE courier SET status='BUSY' WHERE courier_id=?", [selected.courier_id]);
    await connection.commit();
    return NextResponse.json({ message: "Courier allocated", selected, considered: scored.length });
  } catch (error) {
    await connection.rollback();
    return NextResponse.json({ error: error instanceof Error ? error.message : "Allocation failed" }, { status: 400 });
  } finally {
    connection.release();
  }
}
