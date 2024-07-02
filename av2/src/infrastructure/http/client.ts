import axios, { AxiosInstance } from "axios";

interface Order {
  "order-id": number
  "order-item-id": number
  "purchase-date": string
  "payments-date": string | null
  "buyer-email": string
  "buyer-name": string
  cpf: string
  "buyer-phone-number": string
  sku: string
  "product-name": string
  "quantity-purchased": number
  currency: string
  "item-price": number
  "ship-service-level": string
  "recipient-name": string
  "ship-address-1": string
  "ship-address-2": string
  "ship-address-3": string
  "ship-city": string
  "ship-state": string
  "ship-postal-code": string
  "ship-country": string
  "ioss-number": string
}


export class OrderService {
  private client: AxiosInstance;

  constructor() {
    this.client = axios.create({
      baseURL: "https://my.api.mockaroo.com",
      headers: {
        "X-API-Key": "03736a40",
      },
    });
  }

  getAll() {
    return this.client.get<Order[]>("/orders");
  }
}
