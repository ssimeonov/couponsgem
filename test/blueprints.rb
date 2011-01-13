require 'machinist/active_record'
require 'sham'

Sham.define do
  name { Faker::Lorem.words(5).join(' ') }
  description { Faker::Lorem.paragraphs(1).join("\n\n") }
  
  
  
end

Coupon.blueprint do
  name { Sham.name }
  description { Sham.description }
  expiration { Time.now + 3.days }
  limit { 50 }
  category_one { "main" }
  amount_one { 0 }
  percentage_one { 50 }
  alpha_mask { "aa-bb-cc"}
  digit_mask { "11-22-333"}
end