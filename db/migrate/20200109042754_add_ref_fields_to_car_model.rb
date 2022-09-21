class AddRefFieldsToCarModel < ActiveRecord::Migration[5.2]
  def change
    add_reference :car_models, :car_category, foreign_key: true
    add_reference :car_models, :manufacturer, foreign_key: true
  end
end
