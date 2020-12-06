class CreateWizardFriendsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :wizard_friends do |t|
      t.integer :friend_id
      t.integer :added_friend_id
    end
  end
end
