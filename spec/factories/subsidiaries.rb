FactoryBot.define do
  factory :subsidiary do
    name { 'Carrefour Giovanni Gronchi' }
    cnpj { '41298631000116' }
    address { 'Rua Alberto Augusto Alves' }
    number { 50 }
    district { 'Vila Andrade' }
    state { 'SP' }
    city { 'São Paulo' }
    zip_code { '05724030' }
  end
end
