import { NextResponse } from "next/server";
import { pool } from "@/lib/mysql";
import { getMongoDb } from "@/lib/mongodb";

export const dynamic = "force-dynamic";

export async function GET() {
  const result: Record<string, unknown> = {
    mysql: "not checked",
    mongodb: "not checked",
    configuredDatabase: process.env.MYSQL_DATABASE || "MISSING",
  };
  try {
    const [rows]: any = await pool.query("SELECT DATABASE() AS db, COUNT(*) AS customerCount FROM customer");
    result.mysql = "connected";
    result.connectedDatabase = rows[0]?.db;
    result.customerCount = Number(rows[0]?.customerCount ?? 0);
  } catch (error) {
    result.mysql = error instanceof Error ? error.message : String(error);
  }
  try {
    const db = await getMongoDb();
    await db.command({ ping: 1 });
    result.mongodb = "connected";
  } catch (error) {
    result.mongodb = error instanceof Error ? error.message : String(error);
  }
  const ok = result.mysql === "connected";
  return NextResponse.json(result, { status: ok ? 200 : 503 });
}
