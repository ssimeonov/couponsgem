require 'test_helper'

class CouponsControllerTest < ActionController::TestCase
  context "default" do
    should "get the index page" do
      Coupon.make
      get :index
      # assert_select "tr", :minimum => 2
      assert_response(:success)
    end
    
    should "create a 5 coupons" do
      assert_difference 'Coupon.count', 5 do
        post :create, {:how_many => '5', :coupon => Coupon.make_unsaved.attributes}
      end
    end
  end
end
