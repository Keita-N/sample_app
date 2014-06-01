FactoryGirl.define do
  factory :user do
 		sequence(:name)  { |n| "Person #{n}" }
	  sequence(:email) { |n| "person_#{n}@example.com"}   
    password "foobar"
    password_confirmation "foobar"
    sequence(:login_name) { |n| "Person-#{n}" }

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
end