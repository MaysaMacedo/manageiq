class CreateAssetsDetails < ActiveRecord::Migration[5.0]
  def change
    create_table :assets_details do |t|
      t.text  :description
      t.text  :location
      t.text  :room_id
      t.text  :rack_name
      t.text  :lowest_rack_unit
    end
  end
end
