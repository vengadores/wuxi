uri = ENV["REDIS_URL"] || "redis://localhost:6379/0"
app_name = "wuxi"

Sidekiq.configure_server do |config|
 config.redis = { url: uri, namespace: "#{app_name}_#{Rails.env}" }
end

Sidekiq.configure_client do |config|
 config.redis = { url: uri, namespace: "#{app_name}_#{Rails.env}" }
end
