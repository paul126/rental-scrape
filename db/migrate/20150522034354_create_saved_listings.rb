class CreateSavedListings < ActiveRecord::Migration
  def change
    create_table :saved_listings do |t|
      t.string :street
      t.string :city
      t.string :state
      t.string :zip

      t.string :latitude
      t.string :longitude
      t.timestamps null: false
    end
  end
end
