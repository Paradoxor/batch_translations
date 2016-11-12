module ActionView
  module Helpers
    class FormBuilder
      def globalize_fields_for(locale, field_options = {}, &proc)
        raise ArgumentError, "Missing block" unless block_given?

        object_name = "#{@object_name}[translations_attributes][#{locale}]"
        object = @object.translations.select { |t| t.locale.to_s == locale.to_s }.first || @object.translations.find_by_locale(locale.to_s)

        form_options = field_options.reverse_merge(@options.slice(:builder))

        if @template.respond_to? :simple_fields_for
          @template.simple_fields_for(object_name, object, form_options, &proc)
        elsif @template.respond_to? :semantic_fields_for
          @template.semantic_fields_for(object_name, object, form_options, &proc)
        else
          @template.fields_for(object_name, object, form_options, &proc)
        end
      end
    end
  end
end

# ----------------------------------------------------------------
# ----------------------------------------------------------------

module Globalize
  module ActiveRecord
    module InstanceMethods
      def self.extract_translations_attributes(attributes)
        permitted_attributes = attributes.to_h.symbolize_keys

        common_attributes = permitted_attributes.reject { |key, value| key == :translations_attributes }
        translations_attributes = (permitted_attributes[:translations_attributes]) ? permitted_attributes[:translations_attributes].symbolize_keys : nil

        [common_attributes, translations_attributes]
      end

      # ----------------------------------------------------------------

      def self.included(base)
        base.class_eval %{
					alias_method :rails_assign_attributes, :assign_attributes
					
					def assign_attributes(attributes = {})
						if self.class.translates?
							common_attributes, translations_attributes = Globalize::ActiveRecord::InstanceMethods.extract_translations_attributes(attributes)
							rails_assign_attributes(common_attributes)
							
							unless translations_attributes.nil?
				        translations_attributes.keys.each do |locale|
				          translation = translation_for(locale) ||
				                        translations.build(:locale => locale.to_s)

				          translations_attributes[locale].each do |key, value|
				            translation.send :"\#{key}=", value
				          end
								end
							end
						else
							rails_assign_attributes(attributes)
						end
					end
				}
      end
    end
  end
end

# ----------------------------------------------------------------
# ----------------------------------------------------------------

module ActionController
  class Parameters
    # Set the languages used in the application configuration:
    # > config.i18n.available_locales
    # and call like
    # params.require(:post).permit_with_translations([:author_id], :title, :body)
    # params.require(:post).permit_with_translations([:untranslated_param_1, :untranslated_param_2], :translated_param_1, :translated_param_2)
    def permit_with_translations(common, *filters)
      translated_params = []
      untranslated_params = []

      I18n.available_locales.each do |locale|
        translated_params << {locale => filters}
      end

      permitted_params_with_translations = {translations_attributes: translated_params}

      common.each do |param|
        if param.is_a?(Hash)
          permitted_params_with_translations.merge!(param)
        else
          untranslated_params << param
        end
      end

      self.permit(untranslated_params, permitted_params_with_translations)
    end
  end
end

