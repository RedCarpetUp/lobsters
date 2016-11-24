class EditIsInvestorColumn < ActiveRecord::Migration
  def change
  	remove_column :users, :is_investor
  	add_column :users, :is_investor, :boolean, :default => false
  end
end
