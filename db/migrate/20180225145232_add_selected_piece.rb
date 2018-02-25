class AddSelectedPiece < ActiveRecord::Migration[5.1]
  def change
    add_column :games, :selected_piece_id, :integer, after: :turn
  end
end
