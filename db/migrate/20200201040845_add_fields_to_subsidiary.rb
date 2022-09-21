class AddFieldsToSubsidiary < ActiveRecord::Migration[5.2]
  def change
    add_column :subsidiaries, :zip_code, :string
    add_column :subsidiaries, :number, :integer
    add_column :subsidiaries, :district, :string
    add_column :subsidiaries, :state, :string
    add_column :subsidiaries, :city, :string
  end
end
