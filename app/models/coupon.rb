require 'errors'

class Coupon < ActiveRecord::Base
  has_many :redemptions
  validates :name, :presence => true
  validates :description, :presence => true
  validates :expiration, :presence => true
  validates :how_many, :presence => true, :numericality => true
  validates :category_one, :presence => true
  validates  :amount_one, :presence => true, :numericality => true
  validates :percentage_one, :presence => true, :numericality => true
  #TODO: *_two validations
  
  validates :alpha_mask, :presence => true, :format => {:with => /^[a-zA-Z]+(-[a-zA-Z]+)*$/}
  validates :digit_mask, :presence => true, :format => {:with => /^\d+(-\d+)*$/}
  
  before_create do
    self.digit_code = generate_digit_code
    self.alpha_code = generate_alpha_code
  end
  
  scope :not_expired, lambda {
    where(["expiration >= ?", Time.now])
  }
  
  scope :not_used_up, lambda {
    where("coupons.redemptions_count < coupons.how_many")
  }
  
  scope :with_code, lambda { |code| 
    stripped = code.gsub(/[^\w]/, '')
    where(["alpha_code = ? OR digit_code = ?", stripped, stripped]).
    limit(1)
  }
  
  scope :for_category, lambda { |category|
    where(["category = ?", category])
  }
  
  def savings_in_cents(category, cost_in_cents)
    if category == category_one
      cost_in_cents - ((cost_in_cents - amount_one) * (1.0 - (percentage_one.to_f/100.to_f)))      
    elsif category == category_two
      cost_in_cents - ((cost_in_cents - amount_two) * (1.0 - (percentage_two.to_f/100.to_f)))
    else
      0
    end
  end
  
  def self.apply(coupon_code, product_bag = {})
    r = {:savings => 0, :grand_total => 0}
    coupon = find_coupon(coupon_code)
    product_bag.each do |category, price_in_cents|
      price_in_cents = Integer(price_in_cents)
      r[:grand_total] += price_in_cents
      r[category] = price_in_cents
      if coupon
        savings = Money.new(coupon.savings_in_cents(category, price_in_cents)).cents
        r[:savings] += savings
        r[:grand_total] -= savings
        r[category] -= savings
      end
    end
    return r
  end
  
  def self.redeem(coupon_code, user_id, tx_id, metadata)
    coupon = find_coupon(coupon_code)
    coupon.redemption.create!(:transaction_id => tx_id, :user_id => user_id, :metadata => metadata)    
  end
   
  private
  
  def self.find_coupon(coupon_code)
    raise CouponNotFound if Coupon.with_code(coupon_code).empty?
    coupon = Coupon.with_code(coupon_code).first
    raise CouponRanOut unless Coupon.not_used_up.include?(coupon)
    raise CouponExpired unless Coupon.not_expired(coupon).include?(coupon)
    return coupon
  end
   
  def generate_alpha_code
    string_pool =  [('A'..'Z')].map{|i| i.to_a}.flatten;  
    string  =  (1..alpha_mask.gsub(/-/,'').size).map{ string_pool[rand(string_pool.length)]  }.join;
    while Coupon.find_by_alpha_code(string)
      string = (1..alpha_mask.gsub(/-/,'').size).map{ string_pool[rand(string_pool.length)]  }.join;
    end
    return string
  end
  
  def generate_digit_code
    digit_pool = [(0..9)].map{|i| i.to_a}.flatten; 
    digit = (1..digit_mask.gsub(/-/,'').size).map{ digit_pool[rand(digit_pool.length)]  }.join;
    
    while Coupon.find_by_digit_code(digit)
      digit = (1..digit_mask.gsub(/-/,'').size).map{ digit_pool[rand(digit_pool.length)]  }.join;
    end
    
    return digit
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

