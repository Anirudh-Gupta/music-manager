FactoryBot.define do
  factory :album do
    title { Faker::Lorem.word.split(" ").map(&:downcase).join("-")+((1..1000).to_a).sample.to_s }
  end
end