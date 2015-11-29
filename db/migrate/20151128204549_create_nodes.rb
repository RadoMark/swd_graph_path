class CreateNodes < ActiveRecord::Migration
  def change
    create_table :nodes do |t|
      t.string     :store_id, index: true, unique: true, null: false
      t.string     :name
      t.text       :address_line_1
      t.text       :address_line_2
      t.string     :postal_code
      t.string     :city
      t.string     :country
      t.decimal    :latitude, precision: 10, scale: 6
      t.decimal    :longitude, precision: 10, scale: 6
      t.text       :additional_info

      t.timestamps null: false
    end
  end
end
