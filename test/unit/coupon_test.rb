require 'test_helper'

class CouponTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  context "default" do
    should "create default coupon" do
      coupon = Coupon.make 
      assert coupon.alpha_code
      assert coupon.digit_code
    end
    
    should "try to generate codes until they are unique" do
      coupon = Coupon.make 
      new_coupon = Coupon.make_unsaved
      Coupon.expects(:find_by_alpha_code).times(2).returns(coupon, nil)
      Coupon.expects(:find_by_digit_code).times(2).returns(coupon, nil)
      new_coupon.save
    end
    
    should "not find coupon that is expired" do
      coupon = Coupon.make(:expiration => Time.now - 1.day)
      assert_raise CouponExpired do
        Coupon.find_coupon(coupon.alpha_code)
      end
    end
    
    should "not find coupon that has already been used up" do
      coupon = Coupon.make(:how_many => 1)
      coupon.redemptions.create
      assert_raise CouponRanOut do
        Coupon.find_coupon(coupon.alpha_code)
      end
    end
    
    should "not find a coupon that is invalid" do
      assert_raise CouponNotFound do
        Coupon.find_coupon("foobar")
      end
    end
    
    should "find with code" do
      coupon = Coupon.make
      assert Coupon.with_code(coupon.digit_code).include? coupon
    end
  end
  
  context "when applying a valid coupon" do
    setup do
      @coupon = Coupon.make(:category_one => "main", :amount_one => 100, :percentage_one => 10, :category_two => "shipping", :percentage_two => 5, :how_many => 1) 
    end
    
    should "apply a single category" do
      r = Coupon.apply(@coupon.alpha_code, {"main" => 1000})
      assert_equal r, {:savings => 190, :grand_total => 810, "main" => 810}
    end
    
    should "apply both categories" do
      r = Coupon.apply(@coupon.alpha_code, {"main" => 1000, "shipping" => 100 })
      assert_equal r, {:savings => 195, :grand_total => 905, "main" => 810, "shipping" => 95 }
    end
    
    should "apply to no categories" do
      r = Coupon.apply(@coupon.alpha_code, {"foo" => 1000, "bar" => 100 })
      assert_equal r, {:savings => 0, :grand_total => 1100, "foo" => 1000, "bar" => 100 }
    end
  end
   
  context "when redeeming a coupon" do
    
  end
end




# == Schema Information
#
# Table name: coupons
#
#  id                :integer(4)      not null, primary key
#  name              :string(255)
#  description       :string(255)
#  metadata          :text
#  alpha_code        :string(255)
#  alpha_mask        :string(255)
#  digit_code        :string(255)
#  digit_mask        :string(255)
#  category_one      :string(255)
#  amount_one        :integer(4)      default(0)
#  percentage_one    :integer(4)      default(0)
#  category_two      :string(255)
#  amount_two        :integer(4)      default(0)
#  percentage_two    :integer(4)      default(0)
#  expiration        :date
#  limit             :integer(4)      default(1)
#  created_at        :datetime
#  updated_at        :datetime
#  redemptions_count :integer(4)      default(0)
#

