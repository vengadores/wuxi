class ExternalPostsSpeakerWorker
  include Sidekiq::Worker
  sidekiq_options retry: false # scheduled

  def perform
    ::Speaker::TwitterSpeaker.speak!
  end
end
