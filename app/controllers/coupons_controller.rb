class CouponsController < ApplicationController
  
  def apply
    respond_to do |wants|
      wants.js do
        begin
          response = Coupon.apply(params[:coupon_code], params[:product_bag])
        rescue CouponNotFound
          response = {"error" => "Coupon not found" }
        rescue CouponNotApplicable
          response = {"error" => "Coupon does not apply" }
        rescue CouponRanOut
          response = {"error" => "Coupon has run out"}
        rescue CouponExpired
          response = {"error" => "Coupon has expired"}
        end
        render :text => response.to_json
      end
    end    
  end
  
  def redeem
    respond_to do |wants|
      wants.js do
        Coupon.redeem(params[:coupon_code], params[:user_id], params[:tx_id], params[:metadata]).to_json
      end
    end
  end
  
  def index
    if Rails.env.development?
      @coupon = Coupon.new(:how_many => 1, :name => "test", :description => "desc", :category_one => "product", :alpha_mask => "a-a", :digit_mask => "1-2", :amount_one => "1.50", :percentage_one => "10", :expiration => Time.now + 1.year, :how_many => 10)
    else
      @coupon ||= Coupon.new
    end
    @coupons = Coupon.all
    respond_to do |format|
      format.html
      format.csv do
        csv_string = FasterCSV.generate do |csv| 
              csv << ["name","description", "alpha_code", "alpha_mask", "digit_code", "digit_mask", "category_one", "amount_one", "percentage_one", "category_two", "amount_two", "percentage_two", "expiration", "how_many", "redemptions_count"]
              @coupons.each do |c|
                csv << [c.name, c.description, c.alpha_code, c.alpha_mask, c.digit_code, c.digit_mask, c.category_one, c.amount_one, c.percentage_one, c.category_two, c.amount_two, c.percentage_two, c.expiration, c.how_many, c.redemptions_count]
              end
            end
            send_data csv_string, :type => "text/plain", 
             :filename=>"coupons.csv",
             :disposition => 'inline'
      end
    end
  end
  
  def create
    respond_to do |format|
      format.html do
        @coupon = Coupon.new(params[:coupon])
        how_many = params[:how_many] || 1
        unless Coupon.enough_space?(@coupon.alpha_mask, @coupon.digit_mask, Integer(how_many))
          @coupon.errors.add(:alpha_mask, " Alpha/digit mask is not long enough")
          @coupon.errors.add(:digit_mask, " Alpha/digit mask is not long enough")
        end
        if @coupon.errors.empty? && @coupon.valid?
          create_count = 0
          Integer(how_many).times do |i|
            coupon = Coupon.new(params[:coupon])
            if coupon.save
              create_count += 1
            end
          end
          flash[:notice] = "Created #{create_count} coupons"
          redirect_to coupons_path
        else
          flash[:error] = 'Please fix the errors below'
          render :action => "new"
        end
      end
    end
    
    
  end
end
