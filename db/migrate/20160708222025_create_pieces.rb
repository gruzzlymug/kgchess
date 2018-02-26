class CreatePieces < ActiveRecord::Migration[5.1]
  def change
    create_table :pieces do |t|
      t.string :type
      t.integer :pos_x
      t.integer :pos_y
      t.integer :moves, null: false, default: 0
      t.string :status

      t.timestamps null: false
    end
  end
end
