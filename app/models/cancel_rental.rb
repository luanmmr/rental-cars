class CancelRental < ApplicationRecord
  belongs_to :rental

  validates :reason, presence: true

  after_create :change_rental_status

  def change_rental_status
    rental.canceled!
  end
end
