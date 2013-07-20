require 'pp'

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

# ----------------------------------------------------------------
# ----------------------------------------------------------------

module Globalize
  module ActiveRecord
    module InstanceMethods
			def self.extract_translations_attributes(attributes)
				attributes = attributes.symbolize_keys if attributes.respond_to?(:symbolize_keys)
			
				common_attributes = attributes.reject { |key, value| key == :translations_attributes }
				translations_attributes = (attributes[:translations_attributes])? attributes[:translations_attributes].symbolize_keys : nil
			
				[common_attributes, translations_attributes]
			end
			
			# ----------------------------------------------------------------
			
			def self.included(base)
				Rails.logger.info "Globalize included"
				
				base.class_eval %{
					class << self
						alias_method :rails_create, :create
					end
					
					# ----------------------------------------------------------------
					
					alias_method :rails_initialize, :initialize
					alias_method :rails_update, :update
					
					# ----------------------------------------------------------------
				
					def self.create(attributes = {})
						puts "create"
						pp self.class.methods.sort
						
						if self.translates?
							common_attributes, translations_attributes = Globalize::ActiveRecord::InstanceMethods.extract_translations_attributes(attributes)
							self.rails_create(common_attributes)
							save_translations(attributes)
						else
							self.rails_create(attributes)
						end
					end
					
					# ----------------------------------------------------------------
					
					def initialize(attributes = {})
						if self.class.translates?
							common_attributes, translations_attributes = Globalize::ActiveRecord::InstanceMethods.extract_translations_attributes(attributes)
							self.rails_initialize(common_attributes)
							save_translations(attributes)
						else
							self.rails_initialize(attributes)
						end
					end
					
					# ----------------------------------------------------------------
					
					def update(attributes = {})
						if self.class.translates?
							common_attributes, translations_attributes = Globalize::ActiveRecord::InstanceMethods.extract_translations_attributes(attributes)
							self.rails_update(common_attributes)
							save_translations(attributes)
						else
							self.rails_update(attributes)
						end
					end
					
					# ----------------------------------------------------------------
					protected
					# ----------------------------------------------------------------
					
					def save_translations(translations_attributes)
						if translations_attributes
							self.set_translations(translations_attributes)
						end
					end
				}
			end
    end
  end
end
