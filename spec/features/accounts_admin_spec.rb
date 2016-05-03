require "rails_helper"

RSpec.describe "accounts administration",
               type: :feature do
  describe "create new account" do
    let(:admin) { create :admin_user }
    let(:name) { "first account" }

    before {
      login_as admin
      visit new_admin_account_path
      fill_in "Name", with: name
      click_button "Submit"
    }
    subject { Core::Account.last.name }
    it { is_expected.to eq(name) }
    it { expect(page).to have_content(name) }
  end
end
