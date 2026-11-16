import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";

const secret = process.env.JWT_SECRET;
function getSecret() {
  if (!secret) throw new Error("JWT_SECRET is not configured");
  return secret;
}

export async function hashPassword(password: string) {
  return bcrypt.hash(password, 12);
}

export async function verifyPassword(password: string, hash: string) {
  return bcrypt.compare(password, hash);
}

export function createToken(payload: { userId: number; role: "CUSTOMER" | "ADMIN" | "STAFF" }) {
  return jwt.sign(payload, getSecret(), { expiresIn: "8h" });
}
