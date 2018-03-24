require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SmartParkingWeb
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # [Devise] Если вы разворачиваете приложение на Heroku с использованием Rails версии 3.2, то нужно добавить следующую строку
    config.assets.initialize_on_precompile = false

    # устанавливаем локаль по умолчанию на что-либо другое, чем :en
    config.i18n.default_locale = :ru

    # регулирует формат для выгрузки схемы базы данных в файл
    config.active_record.schema_format = :sql
  end
end
