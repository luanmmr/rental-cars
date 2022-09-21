class CarRental < ApplicationRecord
  belongs_to :car
  belongs_to :rental

  validates :daily_price, presence: true, numericality: true
  validates :car_insurance, presence: true, numericality: true
  validates :third_party_insurance, presence: true, numericality: true
  validates :start_mileage, presence: true, numericality: true
  validates :end_mileage, numericality: true
  validate :check_car_category

  after_create :rental_status_change

  private

  def rental_status_change
    rental.in_progress!
  end

  def check_car_category
    return unless car && rental

    errors.add(:base, 'Categoria do carro e da locação não são a mesma.')\
    if car.car_model.car_category != rental.car_category
  end
end
