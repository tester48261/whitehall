FactoryGirl.define do

  factory :upcoming_release_announcement do
    sequence(:title) { |i| "Announcement #{i}" }
    sequence(:summary) { |i| "Announcement summary #{i}" }
    sequence(:release_date) { |i| i.days.from_now }
    document
  end
end
