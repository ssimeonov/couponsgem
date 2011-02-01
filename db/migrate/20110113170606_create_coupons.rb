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
      t.float :amount_one, :default => 0.00
      t.float :percentage_one, :default => 0.00
      
      t.string :category_two
      t.integer :float, :default => 0.00
      t.integer :float, :default => 0.00
      
      t.date :expiration
      t.integer :how_many, :default => 1
      
      t.integer :redemptions_count, :integer, :default => 0
      
      t.timestamps
    end
    # TODO: add indexes
  end

  def self.down
    drop_table :coupons
  end
end
