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

    matcher :match do |expected|
      match do |actual|
        actual.match? expected
      end

      failure_message do |actual|
        message = <<-MESSAGE
          expected:\n#{actual.to_xml.indent 20}

          to match:\n#{expected.to_xml.indent 20}
        MESSAGE

        message.strip_heredoc
      end

      failure_message_when_negated do |actual|
        message = <<-MESSAGE
              expected:\n#{actual.to_xml.indent 24}

          to not match:\n#{expected.to_xml.indent 24}
        MESSAGE

        message.strip_heredoc
      end
    end
  end
end

RSpec.configure do |config|
  config.include MarkupMatcher::NokogiriExampleGroup, file_path: %r{/nokogiri/}
end
