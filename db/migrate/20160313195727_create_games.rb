class CreateGames < ActiveRecord::Migration[5.1]
  def change
    create_table :games do |t|
      t.integer :white_player_id
      t.integer :black_player_id
      t.string :name, null: false
      t.string :status
      t.integer :selected_piece_id
      t.integer :turn, default: 0, null: false
      t.integer :winner_id

      t.timestamps null: false
    end
  end
end
