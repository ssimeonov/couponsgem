class CreateCoupons < ActiveRecord::Migration
  def self.up
    create_table :coupons do |t|
      t.string :name
      t.string :description
      t.text :metadata
      
      t.string :alpha_code
      t.string :alpha_mask
      t.string :digit_code
      t.string :digit_mask
      
      t.string :category_one
      t.integer :amount_one, :default => 0
      t.integer :percentage_one, :default => 0
      
      t.string :category_two
      t.integer :amount_two, :default => 0
      t.integer :percentage_two, :default => 0
      
      t.date :expiration
      t.integer :limit, :default => 1
      
      t.timestamps
    end
  end

  def self.down
    drop_table :coupons
  end
end
