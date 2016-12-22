class Spree::UserPrice < ActiveRecord::Base
  belongs_to :variant, touch: true
  belongs_to :user, class_name: Spree.user_class, foreign_key: 'user_id'
  belongs_to :role

  validates :amount, presence: true
  validates :amount, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :variant, presence: true
  # TODO: validates one of user or role present

  extend Spree::DisplayMoney
  money_methods :amount, :price

  delegate :name, to: :role, prefix: true

  def to_d
    Spree::Money.new(amount, currency: read_attribute(:currency)).to_d
  end

  def currency
    Spree::Money.new(amount, currency: read_attribute(:currency)).currency
  end
end
