class AddIdsToApplQuestions < ActiveRecord::Migration
  def change
  	add_column :appl_questions, :asker_id, :integer
  	add_column :appl_questions, :job_id, :integer
  	add_column :appl_questions, :application_id, :integer
  	add_column :appl_questions, :is_deleted, :boolean
  end
end