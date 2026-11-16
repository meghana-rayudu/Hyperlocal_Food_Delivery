import { NextRequest, NextResponse } from "next/server";
import { pool } from "@/lib/mysql";

export async function GET() {
  try {
    const [rows] = await pool.query("SELECT * FROM order_summary ORDER BY order_time DESC");
    return NextResponse.json(rows);
  } catch {
    return NextResponse.json({ error: "Could not retrieve orders" }, { status: 500 });
  }
}

// Body: { customerId, restaurantId, addressId, items: [{ itemId, quantity }] }
export async function POST(request: NextRequest) {
  const body = await request.json();
  const customerId = Number(body.customerId);
  const restaurantId = Number(body.restaurantId);
  const addressId = Number(body.addressId);
  const items = Array.isArray(body.items) ? body.items : [];

  if (![customerId, restaurantId, addressId].every(Number.isInteger) || !items.length) {
    return NextResponse.json({ error: "Provide customerId, restaurantId, addressId and at least one item." }, { status: 400 });
  }

  const connection = await pool.getConnection();
  try {
    await connection.beginTransaction();
    let total = 0;
    const pricedItems: Array<{ itemId: number; quantity: number; price: number }> = [];

    for (const item of items) {
      const itemId = Number(item.itemId);
      const quantity = Number(item.quantity);
      if (!Number.isInteger(itemId) || !Number.isInteger(quantity) || quantity <= 0) {
        throw new Error("Each item needs a valid itemId and positive integer quantity.");
      }
      const [menuRows]: any = await connection.query(
        "SELECT price FROM menu_item WHERE item_id=? AND restaurant_id=? AND availability=1 FOR UPDATE",
        [itemId, restaurantId]
      );
      if (!menuRows.length) throw new Error(`Menu item ${itemId} is unavailable for this restaurant.`);
      const price = Number(menuRows[0].price);
      total += price * quantity;
      pricedItems.push({ itemId, quantity, price });
    }

    const [orderResult]: any = await connection.query(
      "INSERT INTO orders (customer_id, restaurant_id, address_id, status, total_amount) VALUES (?, ?, ?, 'PLACED', ?)",
      [customerId, restaurantId, addressId, total]
    );
    const orderId = orderResult.insertId;

    for (const item of pricedItems) {
      await connection.query(
        "INSERT INTO order_item (order_id, item_id, quantity, unit_price) VALUES (?, ?, ?, ?)",
        [orderId, item.itemId, item.quantity, item.price]
      );
    }
    await connection.commit();
    return NextResponse.json({ message: "Order created", orderId, totalAmount: total }, { status: 201 });
  } catch (error) {
    await connection.rollback();
    return NextResponse.json({ error: error instanceof Error ? error.message : "Order creation failed" }, { status: 400 });
  } finally {
    connection.release();
  }
}
