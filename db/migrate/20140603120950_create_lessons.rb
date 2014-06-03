class CreateLessons < ActiveRecord::Migration
  def change
    create_table :lessons do |t|
      t.string :name
      t.datetime :start
      t.datetime :ending

      t.timestamps
    end
  end
end
