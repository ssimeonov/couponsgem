class Redemption < ActiveRecord::Base
  belongs_to :coupon, :counter_cache => true
  validates :coupon_id, :presence => true
end


# == Schema Information
#
# Table name: redemptions
#
#  id             :integer(4)      not null, primary key
#  coupon_id      :integer(4)
#  user_id        :string(255)
#  transaction_id :string(255)
#  metadata       :text
#  created_at     :datetime
#  updated_at     :datetime
#

