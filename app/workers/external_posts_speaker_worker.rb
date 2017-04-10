class ExternalPostsSpeakerWorker
  include Sidekiq::Worker

  def perform
    ::Speaker::TwitterSpeaker.speak!
  end
end
