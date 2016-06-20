class AddCurrencyToSpreeUserPrices < ActiveRecord::Migration
  def change
    add_column :spree_user_prices, :currency, :string
  end
end
