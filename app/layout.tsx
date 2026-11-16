import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "Hyperlocal Food Delivery",
  description: "Customer ordering, delivery partner workflow and operations dashboard"
};

export default function RootLayout({ children }: Readonly<{ children: React.ReactNode }>) {
  return <html lang="en"><body>{children}</body></html>;
}
