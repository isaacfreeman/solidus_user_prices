class AddCurrencyToSpreeUserPrices < ActiveRecord::Migration[4.2]
  def change
    add_column :spree_user_prices, :currency, :string
  end
end
