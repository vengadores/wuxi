require 'rails_helper'

RSpec.describe Core::Account,
               type: :model do
  describe "name is unique" do
    let(:first_account) {
      create :core_account
    }
    let(:second_account) {
      build :core_account,
            name: first_account.name
    }

    it {
      expect(second_account).to_not be_valid
    }

    it "valid when name is distinct" do
      second_account.name = "other stuff"
      expect(second_account).to be_valid
    end
  end
end
