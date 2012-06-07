module ::Jade
  class HtmlCompiler < Compiler
    def compile(template)
      template = template.read if template.respond_to?(:read)
      template = context.eval("jade.compile(#{template.to_json}, #{@options.to_json})()")
    end
  end
end
