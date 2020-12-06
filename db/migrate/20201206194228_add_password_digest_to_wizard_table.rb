class AddPasswordDigestToWizardTable < ActiveRecord::Migration[5.2]
  def change
    add_column :wizards, :password_digest, :string
  end
end
