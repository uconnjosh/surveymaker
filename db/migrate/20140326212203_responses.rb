class Responses < ActiveRecord::Migration
  def change
    create_table :responses do |t|
      t.column :answer_option_id, :integer
    end
  end
end
