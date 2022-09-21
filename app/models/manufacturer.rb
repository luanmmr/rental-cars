class Manufacturer < ApplicationRecord
  has_many :car_models, dependent: :destroy

  validates :name, presence: true, uniqueness: { case_sensitive: false },
                   format: { with: /\A[a-zA-Z]{2,}\z/ }
end
