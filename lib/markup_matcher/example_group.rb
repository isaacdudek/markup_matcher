require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/string/indent'
require 'active_support/core_ext/string/strip'

module MarkupMatcher
  module ExampleGroup
    extend RSpec::Matchers::DSL

    matcher :match_markup do |expected|
      match do |actual|
        @options ||= {}

        @options.reverse_merge!(
          allow_extra_attributes: true,
          allow_extra_children: true
        )

        @actual_raw = actual.strip_heredoc.chomp
        @actual_parsed = parse(@actual_raw)

        @expected_raw = expected.strip_heredoc.chomp
        @expected_parsed = parse(@expected_raw)

        @expected_well_formed = standardize(@expected_raw) == standardize(@expected_parsed.to_xml)

        @expected_well_formed && @actual_parsed.match?(@expected_parsed, @options)
      end

      chain :with_options do |options|
        @options = options
      end

      failure_message do
        if @expected_well_formed
          message = <<-MESSAGE
                  expected:\n#{@actual_parsed.to_xml.indent 29}

                  to match:\n#{@expected_parsed.to_xml.indent 29}
          MESSAGE

          if options_for_failure_message.present?
            message << <<-MESSAGE

              with options:  #{options_for_failure_message}
            MESSAGE
          end

          message.strip_heredoc
        else
          <<-MESSAGE.strip_heredoc
            WARNING! Differences were detected after parsing the expected markup.
            The expected markup must be well-formed XML to avoid deformation during parsing.
            Comparison to the actual markup was not performed.

               expected (raw):\n#{@expected_raw.indent 32}

            expected (parsed):\n#{@expected_parsed.to_xml.indent 32}
          MESSAGE
        end
      end

      failure_message_when_negated do
        message = <<-MESSAGE
                expected:\n#{@actual_parsed.to_xml.indent 27}

            to not match:\n#{@expected_parsed.to_xml.indent 27}
        MESSAGE

        if options_for_failure_message.present?
          message << <<-MESSAGE

            with options:  #{options_for_failure_message}
          MESSAGE
        end

        message.strip_heredoc
      end

      def parse(markup)
        ::Nokogiri::XML::Document.parse markup do |config|
          config.noblanks
        end.children.first
      end

      def standardize(markup)
        markup.squish.gsub '> <', '><'
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
  config.include MarkupMatcher::ExampleGroup
end
