require 'test_helper'

class RedemptionTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
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

