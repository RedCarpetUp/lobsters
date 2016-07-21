class AddUserIdToCollcomments < ActiveRecord::Migration
  def change
  	add_column :collcomments, :user_id, :integer
  end
end
