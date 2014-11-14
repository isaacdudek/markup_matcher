module MarkupMatcher
  module Nokogiri
    module XML
      module AttrMatch
        def match?(other)
          name == other.name && value == other.value
        end
      end
    end
  end
end
