FactoryGirl.define do
  factory :user do
 		sequence(:name)  { |n| "Person #{n}" }
	  sequence(:email) { |n| "person_#{n}@example.com"}   
    password "foobar"
    password_confirmation "foobar"
    sequence(:login_name) { |n| "Person-#{n}" }
    state "active"

    factory :admin do
      admin true
    end

    factory :expired_reset_token do
      password_reset_token "hogehoge"
      password_reset_sent_at 3.hours.ago
    end
  end

  factory :micropost do
    content "Lorem ipsum"
    user
  end

  factory :lesson do
    sequence(:name) { |n| "Lesson #{n}" }
    sequence(:start) { |n| Time.now + n.hours }
    sequence(:ending) { |n| Time.now + (n + 2).hours }
  end
end