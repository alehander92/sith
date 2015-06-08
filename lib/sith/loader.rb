module Sith
  def self.load_macros(macro_source)
    lines = macro_source.split("\n")
    macros = {}
    i = 0
    while i < lines.length
      line = lines[i]
      if line.lstrip.start_with? 'macro_mapper'
        offset = line.length - line.lstrip.length
        a = line.index('(')
        label = line[offset + 12...a].strip.to_sym
        args = line[a + 1..-1].rstrip[0...-1].split(/[, \"]/)
        arg = args[0].to_sym
        delimiter =  args.length >= 2 ? args[-1] : "\n"
        end_index = lines[i..-1].find_index { |l| (l[offset..-1] || '').start_with? 'end' }
        body = lines[i + 1...i + end_index].join("\n")
        i = i + end_index + 1
        macros[label] = MacroMapper.new(arg, delimiter, body)
      elsif line.lstrip.start_with? 'macro'
        offset = line.length - line.lstrip.length
        a = line.index('(')
        label = line[offset + 5...a].strip.to_sym
        args = line[a + 1..-1].rstrip[0...-1].split(',').map(&:strip)
        if args.length == 1 && args[0][0] == '*'
          stararg, args = true, [args[0][1..-1].to_sym]
        else
          stararg, args = false, args.map(&:to_sym)
        end
        end_index = lines[i..-1].find_index { |l| (l[offset..-1] || '').start_with? 'end' }
        body = lines[i + 1...i + end_index].join("\n")
        i = i + end_index + 1
        macros[label] = Macro.new(args, stararg, body)
      else
        i += 1
      end
    end
    macros
  end
end
