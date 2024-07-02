export class Product {
  private id?: number;
  private sku: string;
  private name: string;
  private available_quantity: number;

  constructor() {
    this.sku = "";
    this.name = "";
    this.available_quantity = 0;
  }

  getSku(): string {
    return this.sku;
  }

  getName(): string {
    return this.name;
  }

  getAvailableQuantity(): number {
    return this.available_quantity;
  }

  setSku(sku: string): Product {
    this.sku = sku;
    return this;
  }

  setName(name: string): Product {
    this.name = name;
    return this;
  }

  setAvailableQuantity(available_quantity: number): Product {
    this.available_quantity = available_quantity;
    return this;
  }
}