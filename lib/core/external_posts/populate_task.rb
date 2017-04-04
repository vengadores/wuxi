require "core/external_posts/populate_task/populate_twitter"

module Core
  class ExternalPosts
    class PopulateTask
      class << self
        def run!
          external_providers.each do |external_provider|
            new(external_provider).run
          end
        end

        def external_providers
          Core::ExternalProvider.active.all
        end
      end

      def initialize(external_provider)
        @external_provider = external_provider
      end

      def run
        klass_name = @external_provider.provider.classify
        klass = "Core::ExternalPosts::PopulateTask::Populate#{klass_name}"
        klass.constantize.new(@external_provider).run
      end
    end
  end
end
