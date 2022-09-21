class AddDailyRateToCarRentals < ActiveRecord::Migration[5.2]
  def change
    add_column :car_rentals, :daily_rate, :decimal
  end
end
