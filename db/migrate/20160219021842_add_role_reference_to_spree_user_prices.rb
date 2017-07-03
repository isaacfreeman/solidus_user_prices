class AddRoleReferenceToSpreeUserPrices < ActiveRecord::Migration[4.2]
  def change
    add_reference :spree_user_prices, :role, index: true
  end
end
