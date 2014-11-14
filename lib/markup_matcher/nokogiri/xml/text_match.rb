require 'active_support/core_ext/string/filters'

module MarkupMatcher
  module Nokogiri
    module XML
      module TextMatch
        def match?(other)
          content.squish == other.content.squish
        end
      end
    end
  end
end
