class CreateRedemptions < ActiveRecord::Migration
  def self.up
    create_table :redemptions do |t|
      t.references :coupon
      t.string :user_id
      t.string :transaction_id
      t.text :metadata

      t.timestamps
    end
    # TODO: add indexes
  end

  def self.down
    drop_table :redemptions
  end
end
