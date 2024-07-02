import { Product } from "../../domain/entities/product";
import { database } from "../database";

interface ProductRepositoryInterface {
  add: (product: Product) => Promise<void>;
  getBySku: (sku: string) => Promise<Product | null>;
  update: (product: Product) => Promise<void>;
}

export class ProductRepository implements ProductRepositoryInterface {
  async add(product: Product) {
    console.log(`\n📦⏫ Produto ${product.getName()} inserido!`);
    await database.product.create({
      data: {
        sku: product.getSku(),
        name: product.getName(),
        available_quantity: product.getAvailableQuantity(),
      },
    });
  }

  async getBySku(sku: string) {
    const product = await database.product.findUnique({
      where: {
        sku: sku,
      },
    });

    if (!product) {
      return null;
    }

    console.log(`\n📦✅ Produto ${product.name} encontrado!`);
    return new Product()
      .setSku(product.sku)
      .setName(product.name)
      .setAvailableQuantity(product.available_quantity);
  }

  async update(product: Product) {
    console.log(`\n📦🔄 Produto ${product.getName()} atualizado!`);
    await database.product.update({
      where: {
        sku: product.getSku(),
      },
      data: {
        available_quantity: product.getAvailableQuantity(),
      },
    });
  }
}
