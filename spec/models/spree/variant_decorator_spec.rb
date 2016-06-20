require "spec_helper"

describe Spree::Variant do

  subject(:variant) { FactoryGirl.create(:variant, price: 100) }
  let(:user) { FactoryGirl.create :user}
  let(:role) { FactoryGirl.create :role}
  let(:individual_user_price) {Spree::UserPrice.new(variant: variant, user: user, amount: 70)}
  let(:cheaper_individual_user_price) {Spree::UserPrice.new(variant: variant, user: user, amount: 65)}
  let(:role_based_user_price) {Spree::UserPrice.new(variant: variant, role: role, amount: 60)}
  let(:cheapest_role_based_user_price) {Spree::UserPrice.new(variant: variant, role: role, amount: 55)}

  describe "#user_price" do
    context "with no user_prices" do
      it "returns the normal variant price" do
        expect(variant.user_price(user)).to eq 100
      end
    end
    context "with an individual user_price" do
      before :each do
        variant.user_prices << individual_user_price
      end
      it "returns the user_price" do
        expect(variant.user_price(user)).to eq individual_user_price.amount
      end
    end
    context "with a role-based user_price" do
      before :each do
        user.spree_roles << role
        variant.user_prices << role_based_user_price
      end
      it "returns the user_price" do
        expect(variant.user_price(user)).to eq role_based_user_price.amount
      end
    end
    context "with multiple user_prices" do
      before :each do
        user.spree_roles << role
        variant.user_prices << individual_user_price
        variant.user_prices << cheaper_individual_user_price
        variant.user_prices << role_based_user_price
        variant.user_prices << cheapest_role_based_user_price
      end
      it "returns the lowest user_price" do
        expect(variant.user_price(user)).to eq cheapest_role_based_user_price.amount
      end
    end
  end

  describe '#user_price_in' do
    let(:currency) { 'EUR' }
    subject { variant.user_price_in(currency, user).display_amount }

    context "when user is not specified" do
      let(:user) { nil }
      it "returns normal user_price" do
        expect(subject.to_s).to eql variant.price_in(currency).display_amount.to_s
      end
    end

    context "when user has no user_prices" do
      it "returns normal user_price" do
        expect(subject.to_s).to eql variant.price_in(currency).display_amount.to_s
      end
    end

    context "when user has prices in EUR" do
      before do
        variant.user_prices << Spree::UserPrice.new(variant: variant, currency: "EUR", user: user, amount: 33.33)
        variant.user_prices << Spree::UserPrice.new(variant: variant, currency: "EUR", user: user, amount: 23.33)
      end
      it "returns the lowest value in EUR" do
        expect(subject.to_s).to eql "€23.33"
      end
      it "returns the normal price in CAD" do
        expect(variant.user_price_in("CAD", user).display_amount.to_s).to eql variant.price_in("CAD").display_amount.to_s
      end
    end
  end

end
