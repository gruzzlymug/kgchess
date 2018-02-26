FactoryBot.define do
  sequence :email do |n|
    "robot#{n}@test.com"
  end
end
