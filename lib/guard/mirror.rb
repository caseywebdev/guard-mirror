require 'guard'
require 'guard/guard'
require 'sprockets'
require 'coffee_script'
require 'jade'
require "#{File.dirname __FILE__}/../jade/html_compiler.rb"
require "#{File.dirname __FILE__}/../jade/html_template.rb"
require 'stylus'
require 'closure-compiler'
require 'yui/compressor'

module ::Guard
  class Mirror < Guard

    def initialize watchers = [], options = {}
      super

      @options = {
        compress: false
      }.merge options

      @env = ::Sprockets::Environment.new
      @env.register_mime_type 'text/html', '.html'
      @env.register_engine '.jade', ::Jade::HtmlTemplate
      @env.register_engine '.jadet', ::Jade::Template
      @env.register_engine '.styl', ::Tilt::StylusTemplate

      @options[:paths].each { |path| @env.append_path path }

      if @options[:compress]
        @env.js_compressor = ::Closure::Compiler.new
        @env.css_compressor = ::YUI::CssCompressor.new
      end

    end

    def start
      UI.info 'A mirror has started.'
      run_all
    end

    def run_all
      UI.info 'Mirroring all files...'
      if @options[:target]
        paths = [@options[:target]]
      else
        paths = @env.paths.map do |path|
          Dir[File.join path, '**{,/*/**}.*'].map do |file|
            file[path.length + 1 .. -1]
          end
        end.flatten
      end
      run_on_changes paths
    end

    def run_on_changes paths
      (@options[:target] ? [@options[:target]] : paths).each do |path|
        dest = src_to_dest path
        dirname = File.dirname dest
        UI.info "Mirroring #{path}..."
        FileUtils.mkdir_p dirname unless File.directory? dirname
        File.open(dest, 'w') do |f|
          f.write(
            begin
              @env[path]
            rescue => e
              UI.error e.message
              e.message
            end
          )
        end
        UI.info "Saved to #{dest}."
      end
    end

    private

    def src_to_dest path
      path = path
        .sub(/\.coffee|\.jst\.jadet/, '.js')
        .sub(/\.styl/, '.css')
        .sub /\.jade/, '.html'
      File.expand_path "#{@options[:dest]}/#{path}"
    end

  end
end
