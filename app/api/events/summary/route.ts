import { NextResponse } from "next/server";
import { getMongoDb } from "@/lib/mongodb";

export async function GET() {
  try {
    const summary = await (await getMongoDb()).collection("delivery_events").aggregate([
      { $group: { _id: "$eventType", totalEvents: { $sum: 1 }, latestEvent: { $max: "$occurredAt" } } },
      { $sort: { totalEvents: -1 } }
    ]).toArray();
    return NextResponse.json({ collection: "delivery_events", summary });
  } catch {
    return NextResponse.json({ error: "Could not aggregate MongoDB events" }, { status: 500 });
  }
}
