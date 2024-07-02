import { OrderItem } from "../../domain/entities/order-item";
import { database } from "../database";

interface OrderItemRepositoryInterface {
  add: (orderItem: OrderItem) => Promise<void>;
}

export class OrderItemRepository implements OrderItemRepositoryInterface  {
  async add(orderItem: OrderItem): Promise<void> {
    console.log(`\n🛒 Item ${orderItem.getProductName()} inserido!`);
    await database.orderItem.create({
      data: {
        order_id: orderItem.getOrderId(),
        sku: orderItem.getSku(),
        product_name: orderItem.getProductName(),
        purchased_quantity: orderItem.getPurchasedQuantity(),
        currency: orderItem.getCurrency(),
        item_price: orderItem.getItemPrice(),
      }
    })
  }
}