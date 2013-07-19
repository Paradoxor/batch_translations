module ActionView
  module Helpers
    class FormBuilder
      def globalize_fields_for(locale, *args, &proc)
        raise ArgumentError, "Missing block" unless block_given?
				
				object_name = "#{@object_name}[translations_attributes][#{locale}]"
        object = @object.translations.select{|t| t.locale.to_s == locale.to_s}.first || @object.translations.find_by_locale(locale.to_s)
				
        if @template.respond_to? :simple_fields_for
          @template.simple_fields_for(object_name, object, *args, &proc)
        elsif @template.respond_to? :semantic_fields_for
          @template.semantic_fields_for(object_name, object, *args, &proc)
        else
          @template.fields_for(object_name, object, *args, &proc)
        end
      end
    end
  end
end

module Globalize
  module ActiveRecord
    module InstanceMethods
			def self.included(base)
				Rails.logger.info "Globalize included"
				
				base.class_eval %{
					alias_method :rails_update, :update
					
					def update(attributes)
						if self.class.translates?
							attributes = attributes.symbolize_keys if attributes.respond_to?(:symbolize_keys)
						
							self.rails_update(attributes.reject { |key, value| key == :translations_attributes })
						
							if attributes[:translations_attributes]
								self.set_translations(attributes[:translations_attributes].symbolize_keys)
							end
						else
							self.rails_update(attributes)
						end
					end
				}
			end
    end
  end
end
