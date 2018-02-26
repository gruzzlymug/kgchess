FactoryBot.define do
  sequence :email do |n|
    "robot#{n}@test.com"
  end

  sequence :game_name do |n|
    "game #{n}"
  end
end
