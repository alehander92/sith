require 'parser/current'

module Sith
  class BaseMacro
    def represent(node)
      return node.to_s unless node.is_a?(Parser::AST::Node) || node.is_a?(Array)

      if node.is_a?(Array)
        "#{node.map(&method(:represent)).join(', ')}"
      elsif node.type == :int
        node.children[0].to_s
      elsif node.type == :string
        node.children[0]
      elsif node.type == :lvar
        name = node.children[0].to_s
        "(#{name}=#{name}; #{name})"
      elsif :send
        node.children[1].to_s
      else
        '?'
      end
    end

    def expand_macro(nodes)
      a = expand_to_source(nodes)

      Parser::CurrentRuby.parse a
    end
  end

  class Macro < BaseMacro
    attr_reader :labels, :stararg, :template

    def initialize(labels, stararg=false, template='')
      @stararg = stararg
      @labels = labels
      @template = template
    end

    def ==(other)
      return false unless other.is_a?(Macro)
      self.labels == other.labels &&
        self.stararg == other.stararg &&
        self.template.strip == other.template.strip
    end

    def expand_to_source(nodes)
      if @stararg
        substitutions = {@labels[0] => represent(nodes)}
      else
        representations = nodes.map { |node| represent node }
        substitutions = Hash[@labels.zip(representations)]
      end

      @template.gsub(/~\{(\w+)\}/) do |label|
        substitutions[Regexp.last_match(1).to_sym]
      end
    end
  end

  class MacroMapper < BaseMacro
    attr_reader :label, :delimiter, :body

    def initialize(label, delimiter="\n", body='')
      @label = label
      @delimiter = delimiter
      @body = body
    end

    def expand_to_source(nodes)
      macros = nodes.map { |n| Macro.new([label], false, @body)}
      # p macros
      macros.zip(nodes).map { |m, n| m.expand_to_source([n]) }.join(delimiter)
    end
  end
end
