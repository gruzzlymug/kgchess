class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :white_player_id
      t.integer :black_player_id
      t.string :name
      t.string :status
      t.integer :turn
      t.integer :winner_id

      t.timestamps null: false
    end
  end
end