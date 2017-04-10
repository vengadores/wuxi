require "core/external_posts/populate_task"

class ExternalPostsCollectorWorker
  include Sidekiq::Worker

  def perform
    ::Core::ExternalPosts::PopulateTask.run!
  end
end
