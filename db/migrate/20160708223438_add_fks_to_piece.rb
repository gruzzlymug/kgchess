class AddFksToPiece < ActiveRecord::Migration
  def up
    add_column :pieces, :game_id, :integer
    add_column :pieces, :player_id, :integer
  end

  def down
    remove_column :pieces, :game_id
    remove_column :pieces, :player_id
  end
end
