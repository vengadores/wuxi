require "i18n/backend/fallbacks"
I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)
Rails.application.config.i18n.fallbacks = { 'es' => 'en' }
