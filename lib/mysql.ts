import mysql from "mysql2/promise";

const globalForMysql = globalThis as unknown as { mysqlPool?: mysql.Pool };

export const pool = globalForMysql.mysqlPool ?? mysql.createPool({
  host: process.env.MYSQL_HOST,
  port: Number(process.env.MYSQL_PORT || 3306),
  user: process.env.MYSQL_USER,
  password: process.env.MYSQL_PASSWORD,
  database: process.env.MYSQL_DATABASE,
  waitForConnections: true,
  connectionLimit: 10,
  decimalNumbers: true
});

if (process.env.NODE_ENV !== "production") globalForMysql.mysqlPool = pool;
