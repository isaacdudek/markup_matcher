require 'active_support/core_ext/array/access'
require 'active_support/core_ext/hash/reverse_merge'
require 'active_support/core_ext/object/inclusion'

module MarkupMatcher
  module Nokogiri
    module XML
      module ElementMatch
        def match?(other, options = {})
          options.reverse_merge!(
            allow_extra_attributes: false,
            allow_extra_children: false,
            allow_missing_attributes: false,
            allow_missing_children: false
          )

          name == other.name &&
          match_attributes?(attribute_nodes, other.attribute_nodes, options) &&
          match_attributes?(other.attribute_nodes, attribute_nodes, invert_options(options)) &&
          match_children?(children, other.children, options) &&
          match_children?(other.children, children, invert_options(options))
        end

        private

        def invert_options(options)
          options.merge(
            allow_extra_attributes: options[:allow_missing_attributes],
            allow_extra_children: options[:allow_missing_children],
            allow_missing_attributes: options[:allow_extra_attributes],
            allow_missing_children: options[:allow_extra_children]
          )
        end

        def match_attributes?(attributes, other_attributes, options = {})
          attributes.all? do |attribute|
            other_attribute = other_attributes.detect do |other_attribute|
              attribute.name == other_attribute.name
            end

            if other_attribute.present?
              attribute.match? other_attribute
            else
              options[:allow_extra_attributes]
            end
          end
        end

        def match_children?(children, other_children, options = {})
          last_child_match_index = 0

          children.all? do |child|
            last_child_match_index_offset = match_child?(child, other_children.to_a.from(last_child_match_index), options)

            if last_child_match_index_offset.present?
              last_child_match_index += last_child_match_index_offset
            else
              options[:allow_extra_children]
            end
          end
        end

        def match_child?(child, other_children, options = {})
          other_children.each_with_index do |other_child, index|
            return index if case child
            when ::Nokogiri::XML::Element
              child.match? other_child, options
            when ::Nokogiri::XML::Text
              child.match? other_child
            end
          end

          false
        end
      end
    end
  end
end
