class Array
  
  def to_csv(options = {})
    return '' if self.empty?

    options.reverse_merge!(:header => true)

    #columns = self.first.class.content_columns # not include the ID column
    if options[:only]
      columns = Array(options[:only]).map(&:to_sym)
    else
			if self.first.class.respond_to?(:column_names)
				columns = self.first.class.column_names
			elsif self.first.class.respond_to?(:schema)
				columns = self.first.class.schema.keys
			end
			
      columns = columns.map(&:to_sym) - Array(options[:except]).map(&:to_sym)
    end
    
    return '' if columns.empty?
    
    data = []
    # header
    data << (options[:headings] || columns.map(&:to_s).map(&:humanize)).join(', ') if options[:header]

    self.each do |obj|
      data << columns.map{ |column| obj.send(column) }.join(', ')
    end
    data.join("\n")
  end
  
end
