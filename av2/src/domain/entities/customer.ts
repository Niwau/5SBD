export class Customer {
  private id?: number;
  private name: string;
  private cpf: string;
  private phone: string;
  private email: string;

  constructor() {
    this.name = '';
    this.cpf = '';
    this.phone = '';
    this.email = '';
  }

  getName() {
    return this.name;
  }

  getCPF() {
    return this.cpf;
  }

  getPhone() {
    return this.phone;
  }

  getEmail() {
    return this.email;
  }

  setName(name: string) {
    this.name = name;
    return this;
  }

  setCPF(cpf: string) {
    this.cpf = cpf;
    return this;
  }

  setPhone(phone: string) {
    this.phone = phone;
    return this;
  }

  setEmail(email: string) {
    this.email = email;
    return this;
  }
}