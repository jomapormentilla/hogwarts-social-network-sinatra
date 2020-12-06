class RemoveFriendColumnFromWizardsTable < ActiveRecord::Migration[5.2]
  def change
    remove_column :wizards, :friend_id, :integer
    remove_column :wizards, :added_friend_id, :integer
  end
end
