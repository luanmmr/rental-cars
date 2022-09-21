class CarCategory < ApplicationRecord
  has_many :car_models, dependent: :nullify
  has_many :cars, through: :car_models

  validates :name, presence: true, uniqueness: { case_sensitive: false },
                   format: { with: /\A[A-Z]\z/ }
  validates :daily_rate, presence: true, numericality: { greater_than: 1 }
  validates :car_insurance, presence: true, numericality: { greater_than: 1 }
  validates :third_party_insurance, presence: true,
                                    numericality: { greater_than: 1 }
end
