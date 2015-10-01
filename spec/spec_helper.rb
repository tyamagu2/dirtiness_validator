$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'dirtiness_validator'

I18n.load_path += Dir[File.expand_path(File.join(File.dirname(__FILE__), '../locales', '*.yml')).to_s]

class TestModel
  include ActiveModel::Model
  include ActiveModel::Validations
  include ActiveModel::Dirty

  define_attribute_methods :attr

  def attr
    @attr
  end

  def attr=(val)
    return if @attr == val

    attr_will_change!
    @attr = val
  end

  def save
    changes_applied
  end

  def reload!
    clear_changes_information
  end
end
