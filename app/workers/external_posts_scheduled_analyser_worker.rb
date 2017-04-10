class ExternalPostsScheduledAnalyserWorker
  include Sidekiq::Worker
  sidekiq_options retry: false # scheduled

  def perform
    Core::ExternalPost::ScheduledAnalysisService.new.run!
  end
end
