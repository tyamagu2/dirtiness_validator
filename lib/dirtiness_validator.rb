require 'dirtiness_validator/version'
require 'active_model/validations/dirtiness_validator'

module DirtinessValidator
end

ActiveSupport.on_load(:i18n) do
  I18n.load_path += Dir[File.expand_path(File.join(*File.dirname(__FILE__), '..', 'locales', 'en.yml'))]
end
