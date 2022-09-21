class AddDetailsToCarRentals < ActiveRecord::Migration[5.2]
  def change
    add_column :car_rentals, :start_mileage, :integer
    add_column :car_rentals, :end_mileage, :integer
  end
end
