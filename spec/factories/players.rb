FactoryBot.define do
  factory :player do
    email { generate(:email) }
    password 'hahahaha'
    password_confirmation 'hahahaha'
  end
end
