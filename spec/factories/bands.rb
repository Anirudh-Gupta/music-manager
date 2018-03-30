FactoryBot.define do
  factory :band do
    name { Faker::Lorem.word.split(" ").map(&:downcase).join("-")+((1..1000).to_a).sample.to_s }
    members { Faker::Lorem.words }
  end
end