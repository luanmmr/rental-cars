class Car < ApplicationRecord
  belongs_to :car_model
  belongs_to :subsidiary
  has_one :car_rental, dependent: :restrict_with_exception
  has_one :car_category, through: :car_model

  validates :color, presence: true
  validates :license_plate, presence: true, uniqueness: true
  validate :valid_license_plate
  validates :mileage, presence: true, numericality: true

  enum status: { available: 0, under_maintenance: 1 }

  def full_description
    if car_model.nil? || color.nil? || license_plate.nil?
      I18n.t(:incomplete_car, scope:
        %i[activerecord methods car full_description])
    else
      "#{car_model.manufacturer.name} #{car_model.name} - #{color} - "\
      "#{license_plate}"
    end
  end

  def valid_license_plate
    return if license_plate_regex.match license_plate

    errors.add(:license_plate, I18n.t(:invalid_license_plate, scope:
                              %i[activerecord methods car valid_license_plate]))
  end

  private

  def license_plate_regex
    /\A[A-Z]{3}[0-9]{1}([A-Z]{1}|[0-9]{1})[0-9]{2}\z/
  end
end
