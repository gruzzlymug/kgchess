FactoryBot.define do
  factory :game do
    name { generate(:game_name) }

    association :white_player, factory: :player
  end
end
