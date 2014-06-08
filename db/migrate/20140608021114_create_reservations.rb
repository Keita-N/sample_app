class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.integer :user_id
      t.integer :lesson_id

      t.timestamps

    end

    add_index :reservations, :user_id
    add_index :reservations, :lesson_id
    add_index :reservations, [:user_id, :lesson_id], unique: true

  end
end
