class AddFksToPiece < ActiveRecord::Migration
  def up
    change_table :pieces, bulk: true do |t|
      t.belongs_to :game
      t.belongs_to :player
    end
  end

  def down
    change_table :pieces, bulk: true do |t|
      t.remove :game_id
      t.remove :player_id
    end
  end
end
