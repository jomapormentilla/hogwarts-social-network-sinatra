class AddEmailToWizards < ActiveRecord::Migration[5.2]
  def change
    add_column :wizards, :email, :string
  end
end
