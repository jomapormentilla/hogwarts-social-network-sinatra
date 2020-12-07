class AddFounderAndHeadmasterAssociationToWizards < ActiveRecord::Migration[5.2]
  def change
      add_column :wizards, :founder_id, :integer
      add_column :wizards, :head_master_id, :integer
  end
end
