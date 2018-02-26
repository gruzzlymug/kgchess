FactoryBot.define do
  factory :game do
    association :white_player, factory: :player
  end
end
