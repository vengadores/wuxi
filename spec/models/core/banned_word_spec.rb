require "rails_helper"
require "core/external_posts/populate_task/populate_twitter/validator/banned_words_validator"

RSpec.describe Core::BannedWord, type: :model do
  it "banned word validator" do
    bad_word = create(:core_banned_word)
    klass = Core::ExternalPosts::PopulateTask::PopulateTwitter::Validator::BannedWordsValidator
    tweet_mock = double(
      :tweet,
      full_text: "something in here is bad. #{bad_word.content}."
    )
    validator_mock = double(:validator, tweet: tweet_mock)
    subject = klass.new(validator: validator_mock)
    expect(subject).to_not be_permitted_words
    expect(subject.unpermitted_word).to eq(bad_word)
  end
end
