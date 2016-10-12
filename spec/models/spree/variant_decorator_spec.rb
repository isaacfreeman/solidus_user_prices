require "spec_helper"

describe Spree::Variant do
  subject(:variant) { FactoryGirl.create(:variant, price: 100) }
  let(:user) { FactoryGirl.create :user }
  let(:role) { FactoryGirl.create :role }
  let(:individual_user_price) do
    Spree::UserPrice.new(variant: variant, user: user, amount: 70)
  end
  let(:cheaper_individual_user_price) do
    Spree::UserPrice.new(variant: variant, user: user, amount: 65)
  end
  let(:role_based_user_price) do
    Spree::UserPrice.new(variant: variant, role: role, amount: 60)
  end
  let(:cheapest_role_based_user_price) do
    Spree::UserPrice.new(variant: variant, role: role, amount: 55)
  end

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
        expect(
          variant.user_price(user)
        ).to eq cheapest_role_based_user_price.amount
      end
    end
  end

  describe "#user_price_for" do
    subject { variant.user_price_for(Spree::Variant::PricingOptions.new(currency: "USD"), user) }

    context "when user is not specified" do
      let(:user) { nil }
      it "returns normal price" do
        normal_price = variant.price_for(Spree::Variant::PricingOptions.new(currency: "USD")).to_s
        expect(subject.to_s).to eql normal_price
      end
    end

    context "when user has no user_prices" do
      it "returns normal price" do
        normal_price = variant.price_for(Spree::Variant::PricingOptions.new(currency: "USD")).to_s
        expect(subject.to_s).to eql normal_price
      end
    end

    context "when user has prices in EUR" do
      before do
        variant.user_prices << Spree::UserPrice.new(
          variant: variant, currency: "EUR", user: user, amount: 33.33
        )
        variant.user_prices << Spree::UserPrice.new(
          variant: variant, currency: "EUR", user: user, amount: 23.33
        )
      end
      it "returns the lowest value in EUR" do
        eur_user_price = variant.user_price_for(Spree::Variant::PricingOptions.new(currency: "EUR"), user).display_amount.to_s
        expect(eur_user_price).to eql "€23.33"
      end
      it "returns the normal price in USD" do
        usd_normal_price = variant.price_for(Spree::Variant::PricingOptions.new(currency: "USD")).to_s
        usd_user_price = variant.user_price_for(Spree::Variant::PricingOptions.new(currency: "USD"), user).to_s
        expect(usd_user_price).to eql usd_normal_price
      end
    end
  end
end
