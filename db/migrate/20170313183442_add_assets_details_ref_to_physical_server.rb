class AddAssetsDetailsRefToPhysicalServer < ActiveRecord::Migration[5.0]
  def change
    add_reference :physical_servers,  :assets_details,  index:  true, foreign_key: true
  end
end
