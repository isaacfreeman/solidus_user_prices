Spree::Variant.class_eval do
  has_many :user_prices, dependent: :destroy
  accepts_nested_attributes_for :user_prices,
                                allow_destroy: true

  # Return the lowest user_price available to the user
  # Return normal price if no user_prices are available
  def user_price(user)
    return price unless user.present?
    user_prices = user_prices_for(user)
    return price if user_prices.none?
    user_prices.min_by(&:amount).amount
  end

  def user_price_in(currency, user)
    return price_in(currency) unless user.present?
    user_prices = user_prices_for(user).select do |user_price|
      user_price.currency == currency
    end
    return price_in(currency) if user_prices.none?
    user_prices.min_by(&:amount)
  end

  def user_display_price(user = nil)
    user.present? ? Spree::Money.new(user_price(user)) : display_price
  end

  private

  def user_prices_for(user)
    user_prices
      .where(user: user)
      .concat(user_prices.where(role: user.spree_roles))
      .uniq
  end
end
