Spree::Product.class_eval do
  delegate :user_prices, :"user_prices=", :user_price, :user_display_price, to: :find_or_build_master

  def role_price(role)
    user_prices.find_by(role_id: role.id)
  end

  def role_prices
    user_prices.where("role_id IS NOT NULL")
  end
end
