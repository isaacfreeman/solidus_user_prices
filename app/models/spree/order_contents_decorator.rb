# Send user when creating line items, in case special prices
# are available for that user.
module SendUserWhenCreatingLineItems
  private

  def add_to_line_item(variant, quantity, options = {})
    options = options.merge(user: order.user)
    super
  end
end
Spree::OrderContents.prepend SendUserWhenCreatingLineItems
