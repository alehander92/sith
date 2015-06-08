macro_mapper attr_reader(label, delimiter: "\n")
  def ~{label}
  	@~{label}
  end
end

macro_mapper attr_writer(label, delimiter: "\n")
  def ~{label}=(value)
  	@~{label} = value
  end
end

macro attr_accessor(*labels)
  attr_reader ~{labels}
  attr_writer ~{labels}
end

