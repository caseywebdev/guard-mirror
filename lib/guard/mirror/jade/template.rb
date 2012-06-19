module ::Jade
  class Template

  private

    def compile_function
      if file.end_with? '.html.jade'
        Template.default_mime_type = 'text/html'
        compiler = HtmlCompiler
      else
        Template.default_mime_type = 'application/javascript'
        compiler = Compiler
      end

      compiler.new(client: compiler == Compiler, filename: file).compile data
    end
  end
end
