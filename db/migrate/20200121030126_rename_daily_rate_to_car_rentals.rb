class RenameDailyRateToCarRentals < ActiveRecord::Migration[5.2]
  def change
    change_table :car_rentals do |t|
      t.rename :daily_rate, :daily_price
    end
  end
end
