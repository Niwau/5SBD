export class OrderItem {
  private id?: string;
  private order_id: number;
  private sku: string;
  private product_name: string;
  private purchased_quantity: number;
  private currency: string;
  private item_price: number;

  constructor() {
    this.order_id = 0;
    this.sku = "";
    this.product_name = "";
    this.purchased_quantity = 0;
    this.currency = "";
    this.item_price = 0;
  }

  getOrderId() {
    return this.order_id;
  }

  getSku() {
    return this.sku;
  }

  getProductName() {
    return this.product_name;
  }

  getPurchasedQuantity() {
    return this.purchased_quantity;
  }

  getCurrency() {
    return this.currency;
  }

  getItemPrice() {
    return this.item_price;
  }

  setOrderId(order_id: number) {
    this.order_id = order_id;
    return this;
  }

  setSku(sku: string) {
    this.sku = sku;
    return this;
  }

  setProductName(product_name: string) {
    this.product_name = product_name;
    return this;
  }

  setPurchasedQuantity(purchased_quantity: number) {
    this.purchased_quantity = purchased_quantity;
    return this;
  }

  setCurrency(currency: string) {
    this.currency = currency;
    return this;
  }

  setItemPrice(item_price: number) {
    this.item_price = item_price;
    return this;
  }
}
