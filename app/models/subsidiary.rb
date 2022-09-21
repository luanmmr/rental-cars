class Subsidiary < ApplicationRecord
  has_many :cars, dependent: :nullify

  validates :name, presence: true
  validates :address, presence: true
  validates :cnpj, presence: true, length: { is: 14 },
                   numericality: { only_integer: true }
  validates :zip_code, presence: true, numericality: { only_integer: true },
                       length: { is: 8 }
  validates :number, presence: true, uniqueness: { scope: :zip_code },
                     numericality: { only_integer: true }
  validates :district, presence: true
  validates :state, presence: true, length: { is: 2 }
  validates :city, presence: true

  def full_description
    if name.present? && address.present?
      "#{name}: #{address}"
    else
      I18n.t(:record_invalid, scope:
        %i[activerecord methods subsidiary full_description])
    end
  end
end
