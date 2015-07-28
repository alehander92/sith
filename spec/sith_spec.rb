$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'parser'
require 'sith'

module Sith
  describe Sith do
    it 'can load macros from your macros definitions' do
      source = <<-RUBY
        macro simple(a, b)
          ~{a} + ~{b}
        end
      RUBY

      expect(Sith::load_macros(source)[:simple]).to eq(Macro.new([:a, :b], false, '~{a} + ~{b}'))
    end

    it 'can load macro mappers from your macros definitions' do
      source = <<-RUBY
        macro_mapper attr_reader(attr, delimiter: ";")
          def ~{attr}
            @~{attr}
          end
        end
        RUBY

      macros = Sith::load_macros(source)
      macro = macros[:attr_reader]
      expect(macro).to be_a MacroMapper
      expect(macro.label).to eq :attr
      expect(macro.body.strip).to eq "def ~{attr}\n            @~{attr}\n          end"
      expect(macro.delimiter).to eq ";"
    end

    describe 'MacroExpander' do
      it 'can expand macros' do
        macros = {simple: Macro.new([:a, :b],
                                    false,
                                    '~{a} + ~{b}')}
        source = <<-RUBY
          a = x + 4
          simple(2, 4)
        RUBY
        expanded = MacroExpander.new(macros).expand(source)
        expect(expanded.children[1].type).to eq :send
        expect(expanded.children[1].children[2].type).to eq :int
      end

      it 'works correctly with local variables' do
        macros = {identity: Macro.new([:value], false, '~{value}')}
        source = <<-RUBY
          str = "hello world"
          identity(str)
        RUBY
        expanded = MacroExpander.new(macros).expand(source)

        expect(expanded.children[1].type).to eq :begin
        expect(expanded.children[1].children[0].type).to eq :lvasgn
        expect(expanded.children[1].children[0].children[0]).to eq :str
        expect(expanded.children[1].children[0].children[1].type).to eq :lvar
        expect(expanded.children[1].children[0].children[1].children[0]).to eq :str
        expect(expanded.children[1].children[1].type).to eq :lvar
        expect(expanded.children[1].children[1].children[0]).to eq :str
      end

      it 'can expand macro mappers' do
        macros = {attr_reader: MacroMapper.new(:attr,
                                         "\n",
                                         "def ~{attr};@~{attr};end")}
        source = <<-RUBY
          class A
            attr_reader a
          end
        RUBY
        expanded = MacroExpander.new(macros).expand(source)
        expect(expanded.children[2].type).to eq :def
        expect(expanded.children[2].children[2].type).to eq :ivar
        expect(expanded.children[2].children[2].children[0]).to eq :@a
      end
    end
  end
end
