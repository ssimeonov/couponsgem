class CouponsController < ApplicationController
  def index
    @coupon ||= Coupon.new
    @coupons = Coupon.all
    respond_to do |format|
      format.html
      format.csv do
        csv_string = FasterCSV.generate do |csv| 
              csv << ["name","description", "alpha_code", "alpha_mask", "digit_code", "digit_mask", "category_one", "amount_one", "percentage_one", "category_two", "amount_two", "percentage_two", "expiration", "limit", "redemptions_count"]
              @coupons.each do |c|
                csv << [c.name, c.description, c.alpha_code, c.alpha_mask, c.digit_code, c.digit_mask, c.category_one, c.amount_one, c.percentage_one, c.category_two, c.amount_two, c.percentage_two, c.expiration, c.limit, c.redemptions_count]
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
        if @coupon.valid?
          create_count = 0
          Integer(params[:how_many] || 1).times do |i|
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
