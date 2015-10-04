require 'active_model'

module ActiveModel
  module Validations
    class DirtinessValidator < ActiveModel::EachValidator
      CHECKS = { greater: :>, greater_or_equal: :>=, less: :<, less_or_equal: :<=,
                 equal: :==, not_equal: :!= }.freeze

      def validate_each(record, attr_name, value)
        return unless record.persisted?

        # check before_type_cast && allow_xxx option

        options.slice(*CHECKS.keys).each do |option, _|
          previous_value = record.__send__("#{attr_name}_was")

          unless value.__send__(CHECKS[option], previous_value)
            record.errors.add(attr_name, option, filtered_options(previous_value))
          end
        end
      end

      protected

      def filtered_options(previous_value)
        options.except(*CHECKS.keys).tap do |tapped|
          tapped[:previous_value] = previous_value
        end
      end
    end
  end
end
