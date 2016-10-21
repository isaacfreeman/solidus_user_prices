Spree::LineItem.class_eval do
  # Overridden to check special prices for particular users or roles
  def set_pricing_attributes
    return handle_copy_price_override if respond_to?(:copy_price)

    self.currency ||= order.currency
    self.cost_price ||= variant.cost_price
    self.money_price = variant.user_price_for(pricing_options, order.user) if price.nil?
    true
  end

  # Overridden to use user prices if available for the order's user
  def options=(options = {})
    return unless options.present?
    # We will be deleting from the hash, so leave the caller's copy intact
    opts = options.dup
    user = opts.delete(:user)

    assign_attributes opts

    # There's no need to call a pricer if we'll set the price directly.
    unless opts.key?(:price) || opts.key?('price')
      self.money_price = variant.user_price_for(pricing_options, user)
    end
  end
end
