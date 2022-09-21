# config/initializers/locale.rb
I18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]

# Permitted locales available for the application
I18n.available_locales = [:'pt-BR']  # Se quiser pode incluir :en

# Set default locale to something other than :en
I18n.default_locale = :'pt-BR'
