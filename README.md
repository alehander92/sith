# sith

sith is a macro preprocessor for Ruby

[![Build Status](https://travis-ci.org/alehander42/sith.svg)](https://travis-ci.org/alehander42/sith)

Still a prototype.

Example:

a macro definitions file:

```ruby
macro_mapper attr_reader(label)
  def ~{label}
  	@~{label}
  end
end

macro_mapper attr_writer(label)
  def ~{label}=(value)
  	@~{label} = value
  end
end

macro attr_accessor(*labels)
  attr_reader ~{labels}
  attr_writer ~{labels}
end
```

a ruby file
```
class A
  attr_accessor a, z
end
```

```zsh
sith ruby_file.rb macro_definitions.rb > output.rb`
```

output.rb

```ruby
class A
  def a
    @a
  end
  def z
    @z
  end
  def a=(value)
    @a = value
  end
  def z=(value)
    @z = value
  end
end
```
# install

`gem install sith`

# thanks

built on top of [parser](https://github.com/whitequark/parser) and [unparser](https://github.com/mbj/unparser) gems.

# similar to

[rubymacros](https://github.com/coatl/rubymacros/)

however, the macros in `sith` are defined using a ruby-like template notation, not a lisp-like ast notation.

# built by

[Alexander Ivanov](http://alehander42.me)
