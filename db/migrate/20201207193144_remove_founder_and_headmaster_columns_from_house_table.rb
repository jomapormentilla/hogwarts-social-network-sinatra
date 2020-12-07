class RemoveFounderAndHeadmasterColumnsFromHouseTable < ActiveRecord::Migration[5.2]
  def change
    remove_column :houses, :founder, :string
    remove_column :houses, :head_master, :string
  end
end
