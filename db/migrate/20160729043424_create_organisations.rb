class CreateOrganisations < ActiveRecord::Migration
  def change
    create_table :organisations do |t|
    	t.string :name
    	t.string :intro
    	t.integer :is_deleted
    	t.integer :owner_id
    	t.timestamps
    end
  end
end
