class ChangeAssetsDetailsId < ActiveRecord::Migration[5.0]
  def change
    change_column :physical_servers, :assets_details_id, :bigint
  end
end
