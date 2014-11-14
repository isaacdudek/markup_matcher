require 'nokogiri'

require 'markup_matcher/nokogiri/xml/attr_match'
require 'markup_matcher/nokogiri/xml/text_match'
require 'markup_matcher/version'

Nokogiri::XML::Attr.send :include, MarkupMatcher::Nokogiri::XML::AttrMatch
Nokogiri::XML::Text.send :include, MarkupMatcher::Nokogiri::XML::TextMatch
