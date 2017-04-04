class ExternalUserThrottlerUnlockerWorker
  include Sidekiq::Worker

  def perform(id, old_status)
    user = Core::ExternalUser.find(id)
    user.update!(status: old_status)
  end
end
