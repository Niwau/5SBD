export class Order {
  private id?: number;
  private purchase_date: Date;
  private payments_date: Date | null;
  private buyer_email: string;
  private buyer_name: string;
  private cpf: string;
  private buyer_phone_number: string;
  private ship_address_1: string;
  private ship_address_2: string;
  private ship_address_3: string;
  private ship_city: string;
  private ship_state: string;
  private ship_postal_code: string;
  private ship_country: string;

  constructor() {
    this.purchase_date = new Date();
    this.payments_date = null;
    this.buyer_email = '';
    this.buyer_name = '';
    this.cpf = '';
    this.buyer_phone_number = '';
    this.ship_address_1 = '';
    this.ship_address_2 = '';
    this.ship_address_3 = '';
    this.ship_city = '';
    this.ship_state = '';
    this.ship_postal_code = '';
    this.ship_country = '';
  }

  getPurchaseDate() {
    return this.purchase_date;
  }

  getPaymentsDate() {
    return this.payments_date;
  }

  getBuyerEmail() {
    return this.buyer_email;
  }

  getBuyerName() {
    return this.buyer_name;
  }

  getCPF() {
    return this.cpf;
  }

  getBuyerPhoneNumber() {
    return this.buyer_phone_number;
  }

  getShipAddress1() {
    return this.ship_address_1;
  }

  getShipAddress2() {
    return this.ship_address_2;
  }

  getShipAddress3() {
    return this.ship_address_3;
  }

  getShipCity() {
    return this.ship_city;
  }

  getShipState() {
    return this.ship_state;
  }

  getShipPostalCode() {
    return this.ship_postal_code;
  }

  getShipCountry() {
    return this.ship_country;
  }

  setPurchaseDate(purchase_date: Date) {
    this.purchase_date = purchase_date;
    return this;
  }

  setPaymentsDate(payments_date: Date | null) {
    this.payments_date = payments_date;
    return this;
  }

  setBuyerEmail(buyer_email: string) {
    this.buyer_email = buyer_email;
    return this;
  }

  setBuyerName(buyer_name: string) {
    this.buyer_name = buyer_name;
    return this;
  }

  setCPF(cpf: string) {
    this.cpf = cpf;
    return this;
  }

  setBuyerPhoneNumber(buyer_phone_number: string) {
    this.buyer_phone_number = buyer_phone_number;
    return this;
  }

  setShipAddress1(ship_address_1: string) {
    this.ship_address_1 = ship_address_1;
    return this;
  }

  setShipAddress2(ship_address_2: string) {
    this.ship_address_2 = ship_address_2;
    return this;
  }

  setShipAddress3(ship_address_3: string) {
    this.ship_address_3 = ship_address_3;
    return this;
  }

  setShipCity(ship_city: string) {
    this.ship_city = ship_city;
    return this;
  }

  setShipState(ship_state: string) {
    this.ship_state = ship_state;
    return this;
  }

  setShipPostalCode(ship_postal_code: string) {
    this.ship_postal_code = ship_postal_code;
    return this;
  }

  setShipCountry(ship_country: string) {
    this.ship_country = ship_country;
    return this;
  }
}