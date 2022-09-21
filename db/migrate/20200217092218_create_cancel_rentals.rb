class CreateCancelRentals < ActiveRecord::Migration[5.2]
  def change
    create_table :cancel_rentals do |t|
      t.references :rental, foreign_key: true
      t.text :reason

      t.timestamps
    end
  end
end
