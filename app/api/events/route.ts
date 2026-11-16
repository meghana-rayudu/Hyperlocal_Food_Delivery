import { NextRequest, NextResponse } from "next/server";
import { getMongoDb } from "@/lib/mongodb";

export async function GET(request: NextRequest) {
  try {
    const orderId = request.nextUrl.searchParams.get("orderId");
    const filter = orderId ? { orderId: Number(orderId) } : {};
    const events = await (await getMongoDb()).collection("delivery_events")
      .find(filter).sort({ occurredAt: -1 }).limit(100).toArray();
    return NextResponse.json(events);
  } catch {
    return NextResponse.json({ error: "Could not read MongoDB events. Check MONGODB_URI." }, { status: 500 });
  }
}

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    const orderId = Number(body.orderId);
    const eventType = String(body.eventType || "").trim();
    if (!Number.isInteger(orderId) || !eventType) {
      return NextResponse.json({ error: "orderId and eventType are required." }, { status: 400 });
    }
    const event = {
      orderId,
      deliveryId: body.deliveryId ? Number(body.deliveryId) : null,
      courierId: body.courierId ? Number(body.courierId) : null,
      eventType,
      note: String(body.note || ""),
      location: body.location || null,
      occurredAt: new Date()
    };
    const result = await (await getMongoDb()).collection("delivery_events").insertOne(event);
    return NextResponse.json({ insertedId: result.insertedId }, { status: 201 });
  } catch {
    return NextResponse.json({ error: "Could not store delivery event" }, { status: 500 });
  }
}
