class RenameTransactionField < ActiveRecord::Migration
  def self.up
    rename_column :redemptions, :transaction, :transaction_id
  end

  def self.down
  end
end
