class CreateApplQuestions < ActiveRecord::Migration
  def change
    create_table :appl_questions do |t|
      t.text :question
      t.text :answer
      t.text :raw_answer
      t.timestamps
    end
  end
end