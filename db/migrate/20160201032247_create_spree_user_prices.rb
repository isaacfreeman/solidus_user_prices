class CreateSpreeUserPrices < ActiveRecord::Migration[4.2]
  def change
    create_table :spree_user_prices do |t|
      t.references :variant
      t.references :user
      t.string :display
      t.decimal :amount,      precision: 10, scale: 2
      t.timestamps
    end
  end
end
