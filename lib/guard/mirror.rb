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
      UI.info "A mirror has started."
      run_all
    end

    def run_all
      UI.info "Mirroring all files..."
      run_on_changes(
        @options[:target] ?
        [@options[:target]] :
        Dir[File.join @env.paths.first, '**{,/*/**}.*'].map do |path|
          path[@env.paths.first.length + 1 .. -1]
        end
      )
    end

    def run_on_changes paths
      (@options[:target] ? [@options[:target]] : paths).each do |src|
        dest = src_to_dest src
        dirname = File.dirname dest
        UI.info "Mirroring #{src} -> #{dest}"
        FileUtils.mkdir_p dirname unless File.directory? dirname
        File.open(dest, 'w') do |f|
          f.write(
            begin
              @env[src]
            rescue ExecJS::ProgramError => e
              e
            rescue ExecJS::RuntimeError => e
              e
            end)
        end
      end
      UI.info 'Done.'
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
