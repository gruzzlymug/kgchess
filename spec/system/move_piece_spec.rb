require 'rails_helper'

describe 'Movement', :js => true do
  #let!(:game) { create(:game_with_one_player) }
  let!(:black_player) { create(:player) }

  it 'can drag and drop a piece' do
    visit new_player_registration_path
    fill_in :player_email, with: 'roger@rabbit.com'
    fill_in :player_password, with: 'pa$$w0rd123'
    fill_in :player_password_confirmation, with: 'pa$$w0rd123'
    click_on 'Sign up'

    visit new_game_path
    fill_in :game_name, with: 'Bonkers'
    click_on 'Create Game'

    game = Game.last
    game.join(black_player.id)

    visit games_path
    click_link game.name

    src = find('div[data-x="3"][data-y="6"]')
    dest = find('div[data-x="3"][data-y="4"]')
    puts src
    puts dest
    src.drag_to(dest)

    expect(page).to have_content(game.white_player.email)
    expect(page).to have_content(game.black_player.email)
  end
end
