class ExternalPostsScheduledAnalyserWorker
  include Sidekiq::Worker
  sidekiq_options retry: false # scheduled

  def perform
    # TODO query sentiment140
    Core::ExternalPost::ScheduledAnalysisService.perform_in_BG?
  end
end
