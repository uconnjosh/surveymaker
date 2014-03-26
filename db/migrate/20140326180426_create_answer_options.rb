class CreateAnswerOptions < ActiveRecord::Migration
  def change
    create_table :answer_options do |t|
      t.column :name, :text
      t.column :question_id, :integer
    end
  end
end
