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

  describe "edit existing account" do
    let(:admin) { create :admin_user }
    let(:new_name) { "changed name" }

    before {
      # let's create to make sure
      # it has some data and can
      # target the right one
      create :core_account
    }

    let!(:account) { create :core_account }

    before {
      login_as admin
      visit admin_accounts_path
      within "#account_#{account.id}" do
        click_on "editar"
      end
      fill_in "Name", with: new_name
      click_button "Submit"
    }
    subject { account.reload.name }
    it { is_expected.to eq(new_name) }
    it { expect(page).to have_content(new_name) }
  end
end
