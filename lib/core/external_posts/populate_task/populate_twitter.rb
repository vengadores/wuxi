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
            puts "analyse tweet #{tweet.id}"
            if save?(tweet)
              @saved += 1
            end
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
          ExternalProvider::TwitterClientService.from_external_provider(
            @external_provider
          ).twitter_client
        end
      end
    end
  end
end
