class AddCounterCache < ActiveRecord::Migration
  def self.up
    add_column :coupons, :redemptions_count, :integer, :default => 0
  end

  def self.down
    remove_column :coupons, :redemptions_count
  end
end
