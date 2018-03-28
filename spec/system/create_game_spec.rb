describe 'Gameplay' do
  it 'requires a game to be created' do
    visit new_player_registration_path
    fill_in :player_email, with: 'roger@rabbit.com'
    fill_in :player_password, with: 'pa$$w0rd123'
    fill_in :player_password_confirmation, with: 'pa$$w0rd123'
    click_on 'Sign up'

    visit new_game_path
    fill_in :game_name, with: 'Bonkers'
    click_on 'Create Game'

    visit games_path
    expect(page).to have_content('Bonkers')
  end
end
