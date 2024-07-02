import { Order } from "../../domain/entities/order";
import { database } from "../database";

interface OrderRepositoryInterface {
  add: (order: Order) => Promise<void>;
}

export class OrderRepository implements OrderRepositoryInterface {
  async add(order: Order): Promise<void> {
    console.log(`\n📃 Pedido inserido!`);
    await database.order.create({
      data: {
        buyer_email: order.getBuyerEmail(),
        buyer_name: order.getBuyerName(),
        cpf: order.getCPF(),
        buyer_phone_number: order.getBuyerPhoneNumber(),
        ship_address_1: order.getShipAddress1(),
        ship_address_2: order.getShipAddress2(),
        ship_address_3: order.getShipAddress3(),
        ship_city: order.getShipCity(),
        ship_country: order.getShipCountry(),
        status: order.getStatus(),
        purchase_date: order.getPurchaseDate(),
        payments_date: order.getPaymentsDate(),
        ship_postal_code: order.getShipPostalCode(),
        ship_state: order.getShipState(),
      }
    })
  }
}