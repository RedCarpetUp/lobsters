class RemoveJobIdFromApplQuestions < ActiveRecord::Migration
  def change
  	remove_column :appl_questions, :job_id
  end
end
