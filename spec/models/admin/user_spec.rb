require 'rails_helper'

RSpec.describe Admin::User,
               type: :model do
  describe "factory" do
    subject { build :admin_user }
    it { is_expected.to be_valid }
  end
end
