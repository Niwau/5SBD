/*
  Warnings:

  - You are about to alter the column `order_id` on the `Order` table. The data in that column could be lost. The data in that column will be cast from `String` to `Int`.

*/
-- RedefineTables
PRAGMA defer_foreign_keys=ON;
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_Order" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "order_id" INTEGER NOT NULL,
    "purchase_date" DATETIME NOT NULL,
    "payments_date" DATETIME NOT NULL,
    "buyer_email" TEXT NOT NULL,
    "buyer_name" TEXT NOT NULL,
    "cpf" TEXT NOT NULL,
    "buyer_phone_number" TEXT NOT NULL,
    "ship_address_1" TEXT NOT NULL,
    "ship_address_2" TEXT NOT NULL,
    "ship_address_3" TEXT NOT NULL,
    "ship_city" TEXT NOT NULL,
    "ship_state" TEXT NOT NULL,
    "ship_postal_code" TEXT NOT NULL,
    "ship_country" TEXT NOT NULL,
    "status" INTEGER NOT NULL
);
INSERT INTO "new_Order" ("buyer_email", "buyer_name", "buyer_phone_number", "cpf", "id", "order_id", "payments_date", "purchase_date", "ship_address_1", "ship_address_2", "ship_address_3", "ship_city", "ship_country", "ship_postal_code", "ship_state", "status") SELECT "buyer_email", "buyer_name", "buyer_phone_number", "cpf", "id", "order_id", "payments_date", "purchase_date", "ship_address_1", "ship_address_2", "ship_address_3", "ship_city", "ship_country", "ship_postal_code", "ship_state", "status" FROM "Order";
DROP TABLE "Order";
ALTER TABLE "new_Order" RENAME TO "Order";
CREATE UNIQUE INDEX "Order_order_id_key" ON "Order"("order_id");
PRAGMA foreign_keys=ON;
PRAGMA defer_foreign_keys=OFF;
