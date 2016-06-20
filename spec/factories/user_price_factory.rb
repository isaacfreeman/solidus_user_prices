FactoryGirl.define do
  factory :user_price, class: Spree::UserPrice do
    variant
    role
    user
    amount 10.00
  end
end
