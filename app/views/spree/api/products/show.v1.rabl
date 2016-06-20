object @product
cache [
  I18n.locale,
  @current_user_roles.include?("admin"),
  current_currency,
  root_object,
  @current_api_user
]

attributes(*product_attributes, :updated_at, :has_variants?)
node(:total_on_hand) { |p| p.total_on_hand(@customer) }
node(:display_price) { |p| p.user_display_price(@current_api_user).to_s }
node(:price) { |p| p.user_price(@current_api_user).to_s }

child master: :master do
  extends "spree/api/variants/small"
end

child variants: :variants do
  extends "spree/api/variants/small"
end

child option_types: :option_types do
  attributes(*option_type_attributes)
end

child product_properties: :product_properties do
  attributes(*product_property_attributes)
end

child classifications: :classifications do
  attributes :taxon_id, :position
  child(:taxon) do
    extends "spree/api/taxons/show"
  end
end
