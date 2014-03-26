class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.column :name, :text
      t.column :survey_id, :integer
    end
  end
end
