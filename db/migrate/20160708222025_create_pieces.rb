class CreatePieces < ActiveRecord::Migration
  def change
    create_table :pieces do |t|
      t.string :type
      t.integer :pos_x
      t.integer :pos_y
      t.integer :moves
      t.string :status

      t.timestamps null: false
    end
  end
end
