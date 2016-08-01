class OrganisationsUsersJoin < ActiveRecord::Migration
  def change
    create_table 'organisations_users', :id => false do |t|
      t.column :organisation_id, :integer
      t.column :user_id, :integer
    end
  end
end
