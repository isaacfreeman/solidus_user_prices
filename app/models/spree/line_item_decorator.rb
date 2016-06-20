Spree::LineItem.class_eval do
  # Sets this line item's price, cost price, and currency from this line
  # item's variant if they are nil and a variant is present.
  # Overridden to check special prices for particular users or roles
  def copy_price
    return nil unless variant
    self.price = variant.user_price(order.user) if price.nil?
    self.cost_price = variant.cost_price if cost_price.nil?
    self.currency = variant.currency if currency.nil?
  end

  # Sets the options on the line item according to the order's currency or
  # one passed in.
  # @param options [Hash] options for this line item
  # Overridden to use user prices if available for the order's
  # user
  def options=(options = {})
    return unless options.present?
    # We will be deleting from the hash, so leave the caller's copy intact
    opts = options.dup
    currency = opts.delete(:currency) || order.try(:currency)
    user = opts.delete(:user)
    if currency
      self.currency = currency
      self.price    = variant.user_price_in(currency, user).amount +
                      variant.price_modifier_amount_in(currency, opts)
    else
      self.price    = variant.user_price(user) +
                      variant.price_modifier_amount(opts)
    end
    assign_attributes opts
  end
end
