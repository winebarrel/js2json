require 'json'
require 'v8'

require 'js2json/ruby_scope'
require 'js2json/version'
require 'js2json/v8_converter'

module Js2json
  def js2ruby(expr, options = {})
    unless expr.kind_of?(String)
      raise TypeError, "wrong argument type #{expr.class} (expected String)"
    end

    unless options.kind_of?(Hash)
      raise TypeError, "wrong argument type #{options.class} (expected Hash)"
    end

    cxt = V8::Context.new
    cxt['Ruby']  = Js2json::RubyScope.new
    cxt['load']  = cxt.method(:load)
    cxt['print'] = Kernel.method(:puts)

    expr = "(#{expr})" if options[:bracket_script]
    obj = cxt.eval(expr)

    converter = Js2json::V8Converter.new(options)
    converter.convert_to_ruby(obj)
  end
  module_function :js2ruby

  def js2json(expr, options = {})
    rb_obj = js2ruby(expr, options)
    JSON.pretty_generate(rb_obj)
  end
  module_function :js2json
end
