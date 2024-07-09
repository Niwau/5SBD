import { Customer } from "../domain/entities/customer";
import { Order } from "../domain/entities/order";
import { OrderItem } from "../domain/entities/order-item";
import { Product } from "../domain/entities/product";
import { OrderService } from "../infrastructure/http/client";
import { CustomerRepository } from "../infrastructure/repositories/customer-repositoy";
import { OrderItemRepository } from "../infrastructure/repositories/order-item-repository";
import { OrderRepository } from "../infrastructure/repositories/order-repository";
import { ProductRepository } from "../infrastructure/repositories/product-repository";
import { RestockingRepository } from "../infrastructure/repositories/restocking-repository";
import { database } from "../infrastructure/database";
import express from 'express';

const app = express();

async function main() {
  const restockingRepository = new RestockingRepository();
  const orderItemRepository = new OrderItemRepository();
  const customerRepositoy = new CustomerRepository();
  const productRepository = new ProductRepository();
  const orderRepository = new OrderRepository();
  const orderService = new OrderService();

  const orders = await orderService.getAll()

  app.get('/restocking', async (req, res) => {
    res.json(await restockingRepository.getAll());
  })

  app.get('/order-item', async (req, res) => {
    res.json(await orderItemRepository.getAll());
  });

  app.get('/customer', async (req, res) => {
    res.json(await customerRepositoy.getAll());
  });

  app.get('/product', async (req, res) => {
    res.json(await productRepository.getAll());
  });

  app.get('/order', async (req, res) => {
    res.json(await orderRepository.getAll());
  });


  console.log(`\n📦 Importando ${orders.data.length} pedidos...`)

  for await (const currentOrder of orders.data) {
    /** === Cliente === */
    const customer = await customerRepositoy.getByCPF(currentOrder.cpf);

    if (!customer) {
      const newCustomer = new Customer()
        .setCPF(currentOrder.cpf)
        .setName(currentOrder["buyer-name"])
        .setPhone(currentOrder["buyer-phone-number"])
        .setEmail(currentOrder["buyer-email"]);

      await customerRepositoy.add(newCustomer);
    }

    /** === Pedido === */
    const isPaid = currentOrder["payments-date"] !== null;

    const order = new Order()
      .setPurchaseDate(new Date(currentOrder["purchase-date"]))
      .setPaymentsDate(isPaid ? new Date(currentOrder["payments-date"]!) : null)
      .setBuyerEmail(currentOrder["buyer-email"])
      .setBuyerName(currentOrder["buyer-name"])
      .setCPF(currentOrder.cpf)
      .setBuyerPhoneNumber(currentOrder["buyer-phone-number"])
      .setShipAddress1(currentOrder["ship-address-1"])
      .setShipAddress2(currentOrder["ship-address-2"])
      .setShipAddress3(currentOrder["ship-address-3"])
      .setShipCity(currentOrder["ship-city"])
      .setShipCountry(currentOrder["ship-country"])
      .setShipState(currentOrder["ship-state"])
      .setShipPostalCode(currentOrder["ship-postal-code"])

    await orderRepository.add(order);

    /* === Itens do Pedido === */
    const orderItem = new OrderItem()
      .setOrderId(currentOrder["order-id"])
      .setSku(currentOrder.sku)
      .setProductName(currentOrder["product-name"])
      .setPurchasedQuantity(currentOrder["quantity-purchased"])
      .setCurrency(currentOrder.currency)
      .setItemPrice(currentOrder["item-price"]);

    await orderItemRepository.add(orderItem);

    /** === Produto === */
    const product = await productRepository.getBySku(currentOrder.sku);

    if (!product) {
      const newProduct = new Product()
        .setSku(currentOrder.sku)
        .setName(currentOrder["product-name"])
        .setAvailableQuantity(0);

      await productRepository.add(newProduct);
    }

    /** === Atualizando Estoque === */
    const purchasedQuantity = currentOrder["quantity-purchased"];

    if (
      isPaid &&
      product &&
      product.getAvailableQuantity() >= purchasedQuantity
    ) {
      const diff = product.getAvailableQuantity() - purchasedQuantity;
      product.setAvailableQuantity(Math.max(diff, 0));
      await productRepository.update(product);
    } else {
      const restockingProduct = new Product()
        .setSku(currentOrder.sku)
        .setName(currentOrder["product-name"])
        .setAvailableQuantity(purchasedQuantity);

      restockingRepository.add(restockingProduct, purchasedQuantity);
    }
  }
}

main().then(() => {
  console.log("\n💜 Importação finalizada com sucesso!");
})
.catch((error) => {
  console.error("\n❌ Ocorreu um erro durante a importação:", error);
})
.finally(() => {
  database.$disconnect();
});

app.listen(3000, () => {
  console.log('🚀 Server is running on port 3000');
});