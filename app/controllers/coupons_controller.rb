class CouponsController < ApplicationController
  def index
    @coupons = Coupon.all
  end
  
  def create
    
  end
end
