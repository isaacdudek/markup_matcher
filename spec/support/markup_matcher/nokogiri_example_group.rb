require 'active_support/core_ext/array/extract_options'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/string/indent'
require 'active_support/core_ext/string/strip'

module MarkupMatcher
  module NokogiriExampleGroup
    extend RSpec::Matchers::DSL

    def document
      @document ||= ::Nokogiri::XML::Document.new
    end

    def attr(name, value = nil)
      ::Nokogiri::XML::Attr.new(document, name).tap do |attr|
        attr.value = value.to_s
      end
    end

    def element(name, *args)
      attributes = args.extract_options!

      content = args.first

      ::Nokogiri::XML::Element.new(name, document).tap do |element|
        attributes.each do |name, value|
          element[name] = value
        end

        element.content = content
      end
    end

    def elements(markup)
      ::Nokogiri::XML::Document.parse markup do |config|
        config.noblanks
      end.children.first
    end

    def text(content)
      ::Nokogiri::XML::Text.new content, document
    end

    matcher :match do |expected|
      match do |actual|
        @options ||= {}

        case actual
        when ::Nokogiri::XML::Attr
          actual.match? expected
        when ::Nokogiri::XML::Element
          actual.match? expected, @options
        when ::Nokogiri::XML::Text
          actual.match? expected
        end
      end

      chain :with_options do |options|
        @options = options
      end

      failure_message do |actual|
        message = <<-MESSAGE
            .   expected:\n#{actual.to_xml.indent 27}

            .   to match:\n#{expected.to_xml.indent 27}
        MESSAGE

        if options_for_failure_message.present?
          message << <<-MESSAGE

            with options:  #{options_for_failure_message}
          MESSAGE
        end

        message.strip_heredoc
      end

      failure_message_when_negated do |actual|
        message = <<-MESSAGE
            .   expected:\n#{actual.to_xml.indent 27}

            to not match:\n#{expected.to_xml.indent 27}
        MESSAGE

        if options_for_failure_message.present?
          message << <<-MESSAGE

            with options:  #{options_for_failure_message}
          MESSAGE
        end

        message.strip_heredoc
      end

      def options_for_failure_message
        @options_for_failure_message ||= @options.select do |_, value|
          value.present?
        end
      end
    end
  end
end

RSpec.configure do |config|
  config.include MarkupMatcher::NokogiriExampleGroup, file_path: %r{/nokogiri/}
end
