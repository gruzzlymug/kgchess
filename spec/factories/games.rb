FactoryBot.define do
  factory :game_with_one_player, class: Game do
    name { generate(:game_name) }

    association :white_player, factory: :player
  end

  factory :game_with_two_players, class: Game do
    name { generate(:game_name) }

    association :white_player, factory: :player
    association :black_player, factory: :player
  end
end
