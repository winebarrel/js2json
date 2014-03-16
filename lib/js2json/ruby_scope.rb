module Js2json
  class RubyScope
    def self.convert_from_ruby_to_v8(obj)
      case obj
      when Array
        obj.map {|i| convert_from_ruby_to_v8(i) }
      when Hash
        Hash[*obj.map {|k, v|
          [
            convert_from_ruby_to_v8(k),
            convert_from_ruby_to_v8(v),
          ]
        }.flatten]
      when NilClass, Numeric, Proc, String, TrueClass, FalseClass
        obj
      else
        Js2json::RubyScope::ObjectWrapper.new(obj)
      end
    end


    class ObjectWrapper
      def initialize(obj)
        @obj = obj
      end

      def [](name)
        name = name.to_s

        if name =~ /\A[A-Z]/
          Js2json::RubyScope.convert_from_ruby_to_v8(@obj.const_get(name))
        else
          proc do |*args|
            args.shift
            retval = nil

            if args.last.kind_of?(V8::Function)
              func = args.pop

              block = proc do |*block_args|
                block_args = block_args.map {|i|
                  Js2json::RubyScope.convert_from_ruby_to_v8(i)
                }

                func.call(*block_args)
              end

              retval = @obj.send(name, *args, &block)
            else
              retval = @obj.send(name, *args)
            end

            Js2json::RubyScope.convert_from_ruby_to_v8(retval)
          end
        end
      end
    end # ObjectWrapper

    def [](name)
      obj = Module.const_get(name)
      Js2json::RubyScope.convert_from_ruby_to_v8(obj)
    end
  end
end
