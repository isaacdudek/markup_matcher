require 'spec_helper'

describe MarkupMatcher::Nokogiri::XML::AttrMatch do
  describe '#match?' do
    it 'should match when it has the same name and value' do
      expect(attr('class', 'red')).to match(attr('class', 'red'))
    end

    it 'should not match when it has a different name' do
      expect(attr('class')).to_not match(attr('id'))
    end

    it 'should not match when it has the same name and a different value' do
      expect(attr('class', 'red')).to_not match(attr('class', 'blue'))
    end
  end
end
