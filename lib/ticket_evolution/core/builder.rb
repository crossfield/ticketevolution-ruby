module TicketEvolution
  class Builder < OpenStruct
    include SingularClass

    def initialize(*stuff)
      super
      @table.each do |k, v|
        send("#{k}=", process_datum(v))
      end
    end

    def to_hash
      hash = {}
      @table.each do |k, v|
        hash[k] = from_ostruct(v)
      end
      hash
    end

    # Ruby 1.8.7 / REE compatibility
    def id=(id)
      @table[:id] = id
    end

    def id
      @table[:id]
    end

    private

    def process_datum(v)
      case v.class.to_s.to_sym
      when :Hash
        Datum.new(v)
      when :Array
        v.map{|x| process_datum(x)}
      when :String
        Time.parse(v)
      else
        v
      end
    end

    def from_ostruct(v)
      if v.kind_of? OpenStruct
        v.to_hash
      elsif v.class.to_s == "Array"
        v.map{|x| from_ostruct(x)}
      else
        v
      end
    end

    def method_missing(meth, *args)
      if args.size == 1
        super(meth, process_datum(args.first))
      elsif args.size == 0
        super(meth)
      else
        super(meth, process_datum(args))
      end
    end

    def datum_exists?(name)
      defined?(name.constantize) and defined?(singular_class(name.constantize))
    end

    def class_name_from_url(url)
      url.split('/').reverse.each do |segment|
        return "TicketEvolution::#{segment.capitalize}" if segment.split('')[-1] == 's'
      end
    end
  end
end
