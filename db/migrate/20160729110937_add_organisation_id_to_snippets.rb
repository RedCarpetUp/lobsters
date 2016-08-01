class AddOrganisationIdToSnippets < ActiveRecord::Migration
  def change
  	add_column :snippets, :organisation_id, :integer
  end
end
