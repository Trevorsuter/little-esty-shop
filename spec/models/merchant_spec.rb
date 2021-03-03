require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'validations' do
    it { should have_many(:items) }
    it { should have_many(:invoice_items).through(:items) }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should have_many(:transactions).through(:invoices) }
    it { should have_many(:customers).through(:invoices) }
  end

  describe 'methods' do
    it 'should find all unshipped items' do
      joe = Merchant.create!(name: "Joe Rogan")
      customer = Customer.create!(first_name: "Dana", last_name: "White")
      item1 = joe.items.create!(name: "Basketball", description: "Bouncy", unit_price: 20)
      item2 = joe.items.create!(name: "Baseball", description: "Not Bouncy", unit_price: 10)
      item3 = joe.items.create!(name: "Hockey Puck", description: "Not Bouncy", unit_price: 2)
      inv1 = customer.invoices.create!(status: "completed")
      InvoiceItem.create!(invoice: inv1, item: item1, unit_price: 20, status: "packaged")
      InvoiceItem.create!(invoice: inv1, item: item2, unit_price: 10, status: "packaged")
      InvoiceItem.create!(invoice: inv1, item: item3, unit_price: 2, status: "shipped")

      unshipped_items = 2

      expect(joe.unshipped.length).to eq(unshipped_items)
    end
  end

  describe "instance methods" do
    describe "##items_by_status_true" do
      it "returns all merchant items with status that is true" do
        joe = Merchant.create!(name: "Joe Rogan")
        item1 = joe.items.create!(name: "Basketball", description: "Bouncy", unit_price: 20)
        item2 = joe.items.create!(name: "Baseball", description: "Not Bouncy", unit_price: 10, status: false)
        item3 = joe.items.create!(name: "Hockey Puck", description: "Not Bouncy", unit_price: 2)

        expect(joe.items_by_status_true.count).to eq(2)
        expect(joe.items_by_status_false.count).to eq(1)
      end
    end

    describe "##top_5_items" do
      it "returns the top 5 items by revenue generated" do
        @joe = Merchant.create!(name: "Joe Rogan")
        @item1 = @joe.items.create!(name: "Basketball", description: "Bouncy", unit_price: 2)
        @item2 = @joe.items.create!(name: "Baseball", description: "Not Bouncy", unit_price: 2)
        @item3 = @joe.items.create!(name: "Hockey Puck", description: "Not Bouncy", unit_price: 2)
        @item4 = @joe.items.create!(name: "Not A Baseball", description: "Not Bouncy", unit_price: 2)
        @item5 = @joe.items.create!(name: "not A Hockey Puck", description: "Not Bouncy", unit_price: 2)
        @item6 = @joe.items.create!(name: "Apple", description: "Red", unit_price: 2)
        @customer1 = Customer.create!(first_name: "Dana", last_name: "White")
        @customer2 = Customer.create!(first_name: "John", last_name: "Singer")
        @customer3 = Customer.create!(first_name: "Jack", last_name: "Berry")
        @customer4 = Customer.create!(first_name: "Jill", last_name: "Kellogg")
        @customer5 = Customer.create!(first_name: "Jason", last_name: "Sayles")
        @inv1 = @customer1.invoices.create!(status: "completed")
        @inv2 = @customer2.invoices.create!(status: "completed")
        @inv3 = @customer3.invoices.create!(status: "completed")
        @inv4 = @customer4.invoices.create!(status: "completed")
        @inv5 = @customer5.invoices.create!(status: "completed")
        @inv6 = @customer5.invoices.create!(status: "completed")
        @inv7 = @customer5.invoices.create!(status: "completed")
        @inv1.transactions.create!(result: "success")
        @inv2.transactions.create!(result: "success")
        @inv3.transactions.create!(result: "success")
        @inv4.transactions.create!(result: "success")
        @inv5.transactions.create!(result: "success")
        @inv6.transactions.create!(result: "success")
        @inv7.transactions.create!(result: "failed")
        InvoiceItem.create!(invoice: @inv1, item: @item1, unit_price: 2, quantity: 1, status: "packaged")
        InvoiceItem.create!(invoice: @inv2, item: @item2, unit_price: 2, quantity: 2, status: "packaged")
        InvoiceItem.create!(invoice: @inv3, item: @item3, unit_price: 2, quantity: 3, status: "shipped")
        InvoiceItem.create!(invoice: @inv4, item: @item4, unit_price: 2, quantity: 4, status: "shipped")
        InvoiceItem.create!(invoice: @inv5, item: @item5, unit_price: 2, quantity: 5, status: "shipped")
        InvoiceItem.create!(invoice: @inv6, item: @item6, unit_price: 2, quantity: 2, status: "shipped")
        InvoiceItem.create!(invoice: @inv7, item: @item6, unit_price: 2, quantity: 7, status: "shipped")
        InvoiceItem.create!(invoice: @inv7, item: @item6, unit_price: 2, quantity: 8, status: "shipped")

        expect(@joe.top_5_items_by_revenue.length).to eq(5)
        expect(@joe.top_5_items_by_revenue.include?(@item1)).to eq(false)
        expect(@joe.top_5_items_by_revenue.first).to eq(@item5)
        expect(@joe.top_5_items_by_revenue.second).to eq(@item4)
        expect(@joe.top_5_items_by_revenue.third).to eq(@item3)
        expect(@joe.top_5_items_by_revenue.first.revenue).to eq(10)
      end
    end
  end
end
