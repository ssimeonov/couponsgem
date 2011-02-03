require File.join(File.dirname(File.expand_path(__FILE__)), '..', 'test_helper')

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
    
    should "not create a coupon when the mask is too short" do
      assert !Coupon.enough_space?("a", "1", 11)
      assert Coupon.enough_space?("aa", "11", 10)
      assert !Coupon.enough_space?("a", "100", 27)
    end
    
    should "how_many must be positive" do
      c = Coupon.make_unsaved(:how_many => -1)
      assert !c.valid?
      c.how_many = 1
      assert c.valid?
    end
    
  end
  
  context "when applying a valid coupon" do
    setup do
      @coupon = Coupon.make(:category_one => "main", :amount_one => 1.00, :percentage_one => 10.0, :category_two => "shipping", :percentage_two => 5.0, :how_many => 1) 
    end
    
    should "apply a single category" do
      r = Coupon.apply(@coupon.alpha_code, {"main" => 10.00})
      assert_equal r, {:savings => 1.90, :grand_total => 8.10, "main" => 8.10}
    end
    
    should "apply both categories" do
      r = Coupon.apply(@coupon.alpha_code, {"main" => 10.00, "shipping" => 1.00 })
      assert_equal r, {:savings => 1.95, :grand_total => 9.05, "main" => 8.10, "shipping" => 0.95 }
    end
    
    should "apply to no categories" do
      r = Coupon.apply(@coupon.alpha_code, {"foo" => 10.00, "bar" => 1.00 })
      assert_equal r, {:savings => 0, :grand_total => 11.00, "foo" => 10.00, "bar" => 1.00 }
    end
    
    should "not have savings that exceeds the total amount" do
      r = Coupon.apply(@coupon.alpha_code, {"main" => 0.50, "foo" => 1.00})
      assert_equal r, {:savings => 0.50, :grand_total => 1.00, "main" => 0.00, "foo" => 1.00 }
    end
  end
   
  context "when redeeming a coupon" do
    
  end
end

