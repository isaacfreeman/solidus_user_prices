class AddRoleReferenceToSpreeUserPrices < ActiveRecord::Migration
  def change
    add_reference :spree_user_prices, :role, index: true
  end
end
