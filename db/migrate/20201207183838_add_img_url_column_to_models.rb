class AddImgUrlColumnToModels < ActiveRecord::Migration[5.2]
  def change
    add_column :houses, :img_url, :string
    add_column :spells, :img_url, :string
    add_column :wands, :img_url, :string
    add_column :wizards, :img_url, :string
  end
end
