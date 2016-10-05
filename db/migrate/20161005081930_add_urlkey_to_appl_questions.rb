class AddUrlkeyToApplQuestions < ActiveRecord::Migration
  def change
  	add_column :appl_questions, :urlkey, :string
  end
end
