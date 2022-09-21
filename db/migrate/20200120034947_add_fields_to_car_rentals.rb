class AddFieldsToCarRentals < ActiveRecord::Migration[5.2]
  def change
    add_column :car_rentals, :car_insurance, :decimal
    add_column :car_rentals, :third_party_insurance, :decimal
  end
end
