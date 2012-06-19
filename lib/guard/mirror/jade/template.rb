module ::Jade
  class Template < Tilt::Template

  private

    def compile_function
      if file.end_with? '.html.jade'
        compiler = HtmlCompiler
      else
        compiler = Compiler
      end

      compiler.new(client: compiler == Compiler, filename: file).compile data
    end
  end
end
