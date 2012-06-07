module ::Jade
  class HtmlTemplate < Template
    self.default_mime_type = 'text/html'

  private

    def compile_function
      Jade::HtmlCompiler.new(client: false, filename: file).compile data
    end
  end
end
