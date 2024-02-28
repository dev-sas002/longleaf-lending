FactoryBot.define do
  factory :loan_request do
    address { "123 Main St" }
    loan_term { 6 }
    purchase_price { 200000 }
    repair_budget { 30000 }
    arv { 300000 }
    first_name { "John" }
    email { "john@example.com" }
    phone { "1234567890" }
  end
end
