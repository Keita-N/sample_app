class AddColumnPartToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :part_type, :integer
  end
end
