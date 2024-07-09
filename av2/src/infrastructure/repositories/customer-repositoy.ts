import { Customer } from "../../domain/entities/customer";
import { database } from "../database";

interface CustomerRepositoryInterface {
  add: (customer: Customer) => Promise<void>;
  getByCPF: (cpf: string) => Promise<Customer | null>;
  getAll: () => Promise<any>;
}

export class CustomerRepository implements CustomerRepositoryInterface {
  async add(customer: Customer) {
    await database.customer.create({
      data: {
        name: customer.getName(),
        cpf: customer.getCPF(),
        phone: customer.getPhone(),
        email: customer.getEmail(),
      },
    });
    console.log(`\n💙 Cliente ${customer.getName()} inserido!`);
  }

  async getByCPF(cpf: string) {
    const customer = await database.customer.findUnique({
      where: {
        cpf,
      },
    });

    if (!customer) {
      return null;
    }

    return new Customer()
      .setName(customer.name)
      .setCPF(customer.cpf)
      .setPhone(customer.phone)
      .setEmail(customer.email);
  }

  async getAll() {
    return await database.customer.findMany();
  }
}
