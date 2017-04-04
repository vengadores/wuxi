class ExternalPostAnalyserWorker
  include Sidekiq::Worker

  def perform(id)
    external_post = Core::ExternalPost.find(id)
    Core::ExternalPost::AnalyserService.new(external_post).analyse!
  end
end
