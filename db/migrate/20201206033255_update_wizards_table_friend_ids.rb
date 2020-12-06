class UpdateWizardsTableFriendIds < ActiveRecord::Migration[5.2]
  def change
    add_column :wizards, :added_friend_id, :integer
  end
end
