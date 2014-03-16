module Js2json
  class V8Converter
    def initialize(options = {})
      @options = options
    end

    def convert_to_ruby(obj)
      case obj
      when V8::Array
        obj.map {|i| convert_to_ruby(i) }
      when V8::Function
        convert_to_ruby(obj.to_s)
      when V8::Object
        Hash[*obj.map {|k, v|
          key_conv = @options[:key_conv]
          k = convert_to_ruby(k)
          k = key_conv.call(k) if key_conv
          [k, convert_to_ruby(v)]
        }.flatten]
      else
        conv = @options[:conv]
        conv ? conv.call(obj) : obj
      end
    end
  end
end
