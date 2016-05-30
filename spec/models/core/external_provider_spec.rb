require 'rails_helper'

RSpec.describe Core::ExternalProvider,
               type: :model do
  describe "factory" do
    subject { build :core_external_provider }
    it { is_expected.to be_valid }
  end
end
