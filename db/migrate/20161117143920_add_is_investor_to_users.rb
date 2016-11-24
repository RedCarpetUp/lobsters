class AddIsInvestorToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :is_investor, :boolean
  end
end
