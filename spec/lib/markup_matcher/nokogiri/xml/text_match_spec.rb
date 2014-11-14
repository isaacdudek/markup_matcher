require 'spec_helper'

describe MarkupMatcher::Nokogiri::XML::TextMatch do
  describe '#match?' do
    it 'should match when it has the same content' do
      expect(text('hello')).to match(text('hello'))
    end

    it 'should match when it has the same content and more leading whitespace' do
      expect(text(' hello')).to match(text('hello'))
    end

    it 'should match when it has the same content and less leading whitespace' do
      expect(text('hello')).to match(text(' hello'))
    end

    it 'should match when it has the same content and more trailing whitespace' do
      expect(text('hello ')).to match(text('hello'))
    end

    it 'should match when it has the same content and less trailing whitespace' do
      expect(text('hello')).to match(text('hello '))
    end

    it 'should match when it has the same content and more internal whitespace' do
      expect(text("hello \n world")).to match(text('hello world'))
    end

    it 'should match when it has the same content and less internal whitespace' do
      expect(text('hello world')).to match(text("hello \n world"))
    end

    it 'should not match when it has different content' do
      expect(text('hello')).to_not match(text('goodbye'))
    end
  end
end
