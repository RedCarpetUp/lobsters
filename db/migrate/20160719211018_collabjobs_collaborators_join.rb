class CollabjobsCollaboratorsJoin < ActiveRecord::Migration
  def change
    create_table 'collabjobs_collaborators', :id => false do |t|
      t.column :collabjob_id, :integer
      t.column :collaborator_id, :integer
    end
  end
end
