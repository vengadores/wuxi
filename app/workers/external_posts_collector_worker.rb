require "core/external_posts/populate_task"

class ExternalPostsCollectorWorker
  include Sidekiq::Worker
  sidekiq_options retry: false # because it's scheduled

  def perform
    ::Core::ExternalPosts::PopulateTask.run!
  end
end
