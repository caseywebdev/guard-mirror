module ::Jade
  class HtmlCompiler < Compiler
    def compile(template)
      context.eval("jade.compile(#{template.to_json}, #{@options.to_json})()")
    end
  end
end
