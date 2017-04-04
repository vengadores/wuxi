require "core/external_posts/populate_task"

namespace :external_posts do
  task populate: :environment do
    # Rails.logger.level = 0
    Core::ExternalPosts::PopulateTask.run!
  end

  task speak: :environment do
    Speaker::TwitterSpeaker.speak!
  end
end
