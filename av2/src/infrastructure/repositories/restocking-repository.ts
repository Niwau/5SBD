import { Product } from "../../domain/entities/product";
import { database } from "../database";

interface RestockingRepositoryInterface {
  add: (product: Product, needed_quantity: number) => Promise<void>;
}

export class RestockingRepository implements RestockingRepositoryInterface {
  async add(product: Product, needed_quantity: number) {
    console.log(`\n💛 Produto ${product.getName()} precisa ser reposto!`);
    await database.restocking.create({
      data: {
        needed_quantity,
        product: {
          connect: {
            sku: product.getSku(),
          },
        },
      },
    });
  }
}
