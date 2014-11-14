require 'spec_helper'

describe MarkupMatcher::Nokogiri::XML::ElementMatch do
  describe '#match?' do
    it 'should match when it has the same name' do
      expect(element('div')).to match(element('div'))
    end

    it 'should not match when it has a different name' do
      expect(element('div')).to_not match(element('span'))
    end

    context 'Content' do
      it 'should match when it has the same name and matching content' do
        expect(element('div', 'hello')).to match(element('div', 'hello'))
      end

      it 'should not match when it has the same name and non-matching content' do
        expect(element('div', 'hello')).to_not match(element('div', 'goodbye'))
      end
    end

    context 'Attributes' do
      it 'should match when it has the same name and matching attributes' do
        expect(element('div', class: 'red')).to match(element('div', class: 'red'))
      end

      it 'should not match when it has the same name and non-matching attributes' do
        expect(element('div', class: 'red')).to_not match(element('div', class: 'blue'))
      end

      it 'should not match when it has the same name, matching attributes, and extra attributes' do
        expect(element('div', class: 'red', id: 'logo')).to_not match(element('div', class: 'red'))
      end

      it 'should not match when it has the same name, matching attributes, and missing attributes' do
        expect(element('div', class: 'red')).to_not match(element('div', class: 'red', id: 'logo'))
      end

      it 'should not match when it has the same name, matching attributes, extra attributes, and missing attributes' do
        expect(element('div', class: 'red', id: 'logo')).to_not match(element('div', class: 'red', title: 'Logo'))
      end

      context 'allow_extra_attributes: true' do
        let :options do
          {allow_extra_attributes: true}
        end

        it 'should match when it has the same name, matching attributes, and extra attributes' do
          expect(element('div', class: 'red', id: 'logo')).to match(element('div', class: 'red')).with_options(options)
        end

        it 'should not match when it has the same name, non-matching attributes, and extra attributes' do
          expect(element('div', class: 'red', id: 'logo')).to_not match(element('div', class: 'blue')).with_options(options)
        end

        it 'should not match when it has the same name, matching attributes, extra attributes, and missing attributes' do
          expect(element('div', class: 'red', id: 'logo')).to_not match(element('div', class: 'red', title: 'Logo')).with_options(options)
        end

        it 'should not match when it has the same name, non-matching attributes, extra attributes, and missing attributes' do
          expect(element('div', class: 'red', id: 'logo')).to_not match(element('div', class: 'blue', title: 'Logo')).with_options(options)
        end
      end

      context 'allow_missing_attributes: true' do
        let :options do
          {allow_missing_attributes: true}
        end

        it 'should match when it has the same name, matching attributes, and missing attributes' do
          expect(element('div', class: 'red')).to match(element('div', class: 'red', id: 'logo')).with_options(options)
        end

        it 'should not match when it has the same name, non-matching attributes, and missing attributes' do
          expect(element('div', class: 'red')).to_not match(element('div', class: 'blue', id: 'logo')).with_options(options)
        end

        it 'should not match when it has the same name, matching attributes, extra attributes, and missing attributes' do
          expect(element('div', class: 'red', id: 'logo')).to_not match(element('div', class: 'red', title: 'Logo')).with_options(options)
        end

        it 'should not match when it has the same name, non-matching attributes, extra attributes, and missing attributes' do
          expect(element('div', class: 'red', id: 'logo')).to_not match(element('div', class: 'blue', title: 'Logo')).with_options(options)
        end
      end

      context 'allow_extra_attributes: true, allow_missing_attributes: true' do
        let :options do
          {allow_extra_attributes: true, allow_missing_attributes: true}
        end

        it 'should match when it has the same name, matching attributes, extra attributes, and missing attributes' do
          expect(element('div', class: 'red', id: 'logo')).to match(element('div', class: 'red', title: 'Logo')).with_options(options)
        end

        it 'should not match when it has the same name, non-matching attributes, extra attributes, and missing attributes' do
          expect(element('div', class: 'red', id: 'logo')).to_not match(element('div', class: 'blue', title: 'Logo')).with_options(options)
        end
      end
    end

    context 'Children' do
      it 'should match when it has the same name and matching children' do
        expect(elements(
          <<-HTML
            <section>
              <header></header>
              <footer></footer>
            </section>
          HTML
        )).to match(elements(
          <<-HTML
            <section>
              <header></header>
              <footer></footer>
            </section>
          HTML
        ))
      end

      it 'should not match when it has the same name and matching children in a different order' do
        expect(elements(
          <<-HTML
            <section>
              <header></header>
              <footer></footer>
            </section>
          HTML
        )).to_not match(elements(
          <<-HTML
            <section>
              <footer></footer>
              <header></header>
            </section>
          HTML
        ))
      end

      it 'should not match when it has the same name and non-matching children' do
        expect(elements(
          <<-HTML
            <section>
              <header class="red"></header>
              <footer class="blue"></footer>
            </section>
          HTML
        )).to_not match(elements(
          <<-HTML
            <section>
              <header class="green"></header>
              <footer class="yellow"></footer>
            </section>
          HTML
        ))
      end

      it 'should not match when it has the same name, matching children, and extra children' do
        expect(elements(
          <<-HTML
            <section>
              <div></div>
              <header></header>
              <div></div>
              <div></div>
              <footer></footer>
              <div></div>
            </section>
          HTML
        )).to_not match(elements(
          <<-HTML
            <section>
              <header></header>
              <footer></footer>
            </section>
          HTML
        ))
      end

      it 'should not match when it has the same name, matching children, and missing children' do
        expect(elements(
          <<-HTML
            <section>
              <header></header>
              <footer></footer>
            </section>
          HTML
        )).to_not match(elements(
          <<-HTML
            <section>
              <div></div>
              <header></header>
              <div></div>
              <div></div>
              <footer></footer>
              <div></div>
            </section>
          HTML
        ))
      end

      it 'should not match when it has the same name, matching children, extra children, and missing children' do
        expect(elements(
          <<-HTML
            <section>
              <div></div>
              <header></header>
              <div></div>
              <div></div>
              <footer></footer>
              <div></div>
            </section>
          HTML
        )).to_not match(elements(
          <<-HTML
            <section>
              <span></span>
              <header></header>
              <span></span>
              <span></span>
              <footer></footer>
              <span></span>
            </section>
          HTML
        ))
      end

      it 'should preserve options during recursion' do
        expect(elements(
          <<-HTML
            <section>
              <header>
                <div class="red"></div>
              </header>
              <footer>
                <div class="blue"></div>
              </footer>
            </section>
          HTML
        )).to match(elements(
          <<-HTML
            <section>
              <header>
                <div id="logo"></div>
              </header>
              <footer>
                <div title="Logo"></div>
              </footer>
            </section>
          HTML
        )).with_options(allow_extra_attributes: true, allow_missing_attributes: true)
      end

      it 'should invert options during recursion' do
        expect(elements(
          <<-HTML
            <section>
              <header>
                <div class="red"></div>
              </header>
              <footer>
                <div class="blue"></div>
              </footer>
            </section>
          HTML
        )).to match(elements(
          <<-HTML
            <section>
              <header>
                <div></div>
              </header>
              <footer>
                <div></div>
              </footer>
            </section>
          HTML
        )).with_options(allow_extra_attributes: true)
      end

      context 'allow_extra_children: true' do
        let :options do
          {allow_extra_children: true}
        end

        it 'should match when it has the same name, matching children, and extra children' do
          expect(elements(
            <<-HTML
              <section>
                <div></div>
                <header></header>
                <div></div>
                <div></div>
                <footer></footer>
                <div></div>
              </section>
            HTML
          )).to match(elements(
            <<-HTML
              <section>
                <header></header>
                <footer></footer>
              </section>
            HTML
          )).with_options(options)
        end

        it 'should not match when it has the same name, non-matching children, and extra children' do
          expect(elements(
            <<-HTML
              <section>
                <div></div>
                <header class="red"></header>
                <div></div>
                <div></div>
                <footer class="blue"></footer>
                <div></div>
              </section>
            HTML
          )).to_not match(elements(
            <<-HTML
              <section>
                <header class="green"></header>
                <footer class="yellow"></footer>
              </section>
            HTML
          )).with_options(options)
        end

        it 'should not match when it has the same name, matching children, extra children, and missing children' do
          expect(elements(
            <<-HTML
              <section>
                <div></div>
                <header></header>
                <div></div>
                <div></div>
                <footer></footer>
                <div></div>
              </section>
            HTML
          )).to_not match(elements(
            <<-HTML
              <section>
                <span></span>
                <header></header>
                <span></span>
                <span></span>
                <footer></footer>
                <span></span>
              </section>
            HTML
          )).with_options(options)
        end

        it 'should not match when it has the same name, non-matching children, extra children, and missing children' do
          expect(elements(
            <<-HTML
              <section>
                <div></div>
                <header class="red"></header>
                <div></div>
                <div></div>
                <footer class="blue"></footer>
                <div></div>
              </section>
            HTML
          )).to_not match(elements(
            <<-HTML
              <section>
                <span></span>
                <header class="green"></header>
                <span></span>
                <span></span>
                <footer class="yellow"></footer>
                <span></span>
              </section>
            HTML
          )).with_options(options)
        end
      end

      context 'allow_missing_children: true' do
        let :options do
          {allow_missing_children: true}
        end

        it 'should match when it has the same name, matching children, and missing children' do
          expect(elements(
            <<-HTML
              <section>
                <header></header>
                <footer></footer>
              </section>
            HTML
          )).to match(elements(
            <<-HTML
              <section>
                <div></div>
                <header></header>
                <div></div>
                <div></div>
                <footer></footer>
                <div></div>
              </section>
            HTML
          )).with_options(options)
        end

        it 'should not match when it has the same name, non-matching children, and missing children' do
          expect(elements(
            <<-HTML
              <section>
                <header class="red"></header>
                <footer class="blue"></footer>
              </section>
            HTML
          )).to_not match(elements(
            <<-HTML
              <section>
                <div></div>
                <header class="green"></header>
                <div></div>
                <div></div>
                <footer class="yellow"></footer>
                <div></div>
              </section>
            HTML
          )).with_options(options)
        end

        it 'should not match when it has the same name, matching children, extra children, and missing children' do
          expect(elements(
            <<-HTML
              <section>
                <div></div>
                <header></header>
                <div></div>
                <div></div>
                <footer></footer>
                <div></div>
              </section>
            HTML
          )).to_not match(elements(
            <<-HTML
              <section>
                <span></span>
                <header></header>
                <span></span>
                <span></span>
                <footer></footer>
                <span></span>
              </section>
            HTML
          )).with_options(options)
        end

        it 'should not match when it has the same name, non-matching children, extra children, and missing children' do
          expect(elements(
            <<-HTML
              <section>
                <div></div>
                <header class="red"></header>
                <div></div>
                <div></div>
                <footer class="blue"></footer>
                <div></div>
              </section>
            HTML
          )).to_not match(elements(
            <<-HTML
              <section>
                <span></span>
                <header class="green"></header>
                <span></span>
                <span></span>
                <footer class="yellow"></footer>
                <span></span>
              </section>
            HTML
          )).with_options(options)
        end
      end

      context 'allow_extra_children: true, allow_missing_children: true' do
        let :options do
          {allow_extra_children: true, allow_missing_children: true}
        end

        it 'should match when it has the same name, matching children, extra children, and missing children' do
          expect(elements(
            <<-HTML
              <section>
                <div></div>
                <header></header>
                <div></div>
                <div></div>
                <footer></footer>
                <div></div>
              </section>
            HTML
          )).to match(elements(
            <<-HTML
              <section>
                <span></span>
                <header></header>
                <span></span>
                <span></span>
                <footer></footer>
                <span></span>
              </section>
            HTML
          )).with_options(options)
        end

        it 'should match when it has the same name, non-matching children, extra children, and missing children' do
          expect(elements(
            <<-HTML
              <section>
                <div></div>
                <header class="red"></header>
                <div></div>
                <div></div>
                <footer class="blue"></footer>
                <div></div>
              </section>
            HTML
          )).to match(elements(
            <<-HTML
              <section>
                <span></span>
                <header class="green"></header>
                <span></span>
                <span></span>
                <footer class="yellow"></footer>
                <span></span>
              </section>
            HTML
          )).with_options(options)
        end
      end
    end
  end
end
