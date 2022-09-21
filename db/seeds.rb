# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

subsidiary = Subsidiary.create!(name: 'Aeroporto Congonhas',
                                cnpj: '21393954000181',
                                address: 'Rua Otávio Tarquínio De Souza',
                                number: 379,
                                district: 'Campo Belo',
                                state: 'SP',
                                city: 'São Paulo',
                                zip_code: '04613001')

subsidiary_2 = Subsidiary.create!(name: 'Carrefour Giovanni Gronchi',
                                  cnpj: '41298631000116',
                                  address: 'Av Alberto Augusto Alves',
                                  number: 50,
                                  district: 'Vila Andrade',
                                  state: 'SP',
                                  city: 'São Paulo',
                                  zip_code: '05724030')

subsidiary_3 = Subsidiary.create!(name: 'Santos',
                                  cnpj: '94263501000104',
                                  address: 'Av Ana Costa',
                                  number: 304,
                                  district: 'Gonzaga',
                                  state: 'SP',
                                  city: 'Santos',
                                  zip_code: '11060000')

manufacturer = Manufacturer.create(name: 'Fiat')
manufacturer_2 = Manufacturer.create(name: 'Ford')
manufacturer_3 = Manufacturer.create(name: 'Honda')

car_category = CarCategory.create(name: 'A', daily_rate: 72.20,
                                  car_insurance: 28.00,
                                  third_party_insurance: 10.00)
car_category_2 = CarCategory.create(name: 'B', daily_rate: 92.20,
                                    car_insurance: 35.20,
                                    third_party_insurance: 12.00)
car_category_3 = CarCategory.create(name: 'C', daily_rate: 125.20,
                                    car_insurance: 40.20,
                                    third_party_insurance: 15.50)

car_model = CarModel.create!(name: 'Uno', year: '2018', motorization: '1.5',
                             fuel_type: 'Flex', car_category: car_category,
                             manufacturer: manufacturer)
car_model_2 = CarModel.create!(name: 'Fiesta', year: '2019',
                               motorization: '1.8', fuel_type: 'Flex',
                               car_category: car_category_2,
                               manufacturer: manufacturer_2)
car_model_3 = CarModel.create!(name: 'Civic', year: '2017', motorization: '2.0',
                               fuel_type: 'Flex', car_category: car_category_3,
                               manufacturer: manufacturer_3)
car_model_4 = CarModel.create!(name: 'Punto', year: '2012', motorization: '2.0',
                               fuel_type: 'Flex', car_category: car_category,
                               manufacturer: manufacturer)
car_model_5 = CarModel.create!(name: 'Fusion', year: '2018',
                               motorization: '2.0', fuel_type: 'Flex',
                               car_category: car_category_2,
                               manufacturer: manufacturer_2)
car_model_6 = CarModel.create!(name: 'Fit', year: '2018', motorization: '2.0',
                               fuel_type: 'Flex', car_category: car_category_3,
                               manufacturer: manufacturer_3)

client = Client.create!(name: 'Fulano', document: '2938248684',
                        email: 'fulano@test.com')
client_2 = Client.create!(name: 'Sicrano', document: '1238344486',
                          email: 'sicrano@test.com')
client_3 = Client.create!(name: 'Beltrano', document: '9278245521',
                          email: 'beltrano@test.com')

user = User.create(email: 'luan@hotmail.com', password: '123456')

Car.create!(license_plate: 'MVL7266', color: 'Vermelho', car_model: car_model,
            mileage: 120.00, subsidiary: subsidiary)
Car.create!(license_plate: 'UFC4212', color: 'Azul', car_model: car_model_2,
            mileage: 50.00, subsidiary: subsidiary_2)
Car.create!(license_plate: 'KTY4212', color: 'Preto', car_model: car_model_3,
            mileage: 10.00, subsidiary: subsidiary_3)
Car.create!(license_plate: 'UML6111', color: 'Roxo', car_model: car_model_4,
            mileage: 10.00, subsidiary: subsidiary)
Car.create!(license_plate: 'XUU7117', color: 'Cinza', car_model: car_model_5,
            mileage: 0, subsidiary: subsidiary_2)
Car.create!(license_plate: 'MXA8769', color: 'Rosa', car_model: car_model_6,
            mileage: 150.00, subsidiary: subsidiary_3)

Rental.create!(code: 'XFB0000', start_date: Time.zone.today,
               end_date: 1.day.from_now, client: client,
               car_category: car_category, user: user)
Rental.create!(code: 'XFB0001', start_date: Time.zone.today,
               end_date: 3.day.from_now, client: client_2,
               car_category: car_category_2, user: user)
Rental.create!(code: 'XFB0002', start_date: Time.zone.today,
               end_date: 6.day.from_now, client: client_3,
               car_category: car_category_3, user: user)
