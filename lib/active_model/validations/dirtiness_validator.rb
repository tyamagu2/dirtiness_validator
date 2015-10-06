require 'active_model'

module ActiveModel
  module Validations
    class DirtinessValidator < ActiveModel::EachValidator
      CHECKS = { greater: :>, greater_or_equal: :>=, less: :<, less_or_equal: :<=,
                 equal: :==, not_equal: :!= }.freeze

      def validate_each(record, attr_name, current_value)
        return unless record.persisted?

        # check before_type_cast && allow_xxx option

        options.slice(*CHECKS.keys).each do |option, option_value|
          previous_value = record.__send__("#{attr_name}_was")

          case option_value
          when Symbol
            current_value = current_value.__send__(option_value)
            previous_value = previous_value.__send__(option_value)
          when Proc
            current_value = option_value.call(current_value)
            previous_value = option_value.call(previous_value)
          end

          unless current_value.__send__(CHECKS[option], previous_value)
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
