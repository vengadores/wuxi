require "core/external_posts/populate_task/populate_twitter/saver"

module Core
  class ExternalPosts
    class PopulateTask
      class PopulateTwitter
        def initialize(external_provider)
          @external_provider = external_provider
        end

        def run
          @saved = 0
          search_results.each do |tweet|
            @saved += 1 if save?(tweet)
          end
          puts "saved #{@saved} posts for #{@external_provider}"
        end

        private

        def search_results
          puts "searching #{@external_provider.account.searchterm}"
          twitter_client.search(
            @external_provider.account.searchterm,
            result_type: "recent"
          )
        end

        def save?(tweet)
          Saver.new(tweet: tweet, external_provider: @external_provider).save
        end

        def twitter_client
          ExternalProvider::TwitterClientService.new(
            @external_provider
          ).twitter_client
        end
      end
    end
  end
end
