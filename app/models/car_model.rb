class CarModel < ApplicationRecord
  has_many :cars, dependent: :destroy
  belongs_to :manufacturer
  belongs_to :car_category

  validates :name, presence: true,
                   uniqueness: { case_sensitive: false, scope:
                     %i[year motorization fuel_type] }
  validates :year, presence: true
  validates :motorization, presence: true
  validates :fuel_type, presence: true

  def full_description
    if name && manufacturer && year && motorization && fuel_type
      "#{manufacturer.name} #{name} | #{year} | #{motorization} | #{fuel_type}"
    else
      I18n.t(:incomplete_model, scope:
        %i[activerecord methods car_model full_description])
    end
  end
end
