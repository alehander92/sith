require 'parser/current'
require 'unparser'

module Sith
  class MacroExpander
    def initialize(macros)
      @macros = macros
    end

    def expand(source)
      ast = Parser::CurrentRuby.parse(source)
      expand_node ast
    end

    def expand_to_source(source)
      Unparser.unparse(expand(source))
    end

    def expand_node(node)
      return node unless node.is_a?(Parser::AST::Node)

      if node.type == :send && @macros.key?(node.children[1])
        node = @macros[node.children[1]].expand_macro(node.children[2..-1])
      end

      children = node.children.map(&method(:expand_node))
      Parser::AST::Node.new node.type, children
    end
  end
end

