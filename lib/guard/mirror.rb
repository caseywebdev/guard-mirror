require 'guard'
require 'guard/guard'
require 'sprockets'
require 'coffee_script'
require 'jade'
require_relative 'mirror/jade/html_compiler'
require_relative 'mirror/jade/template'
require 'stylus'
require 'closure-compiler'
require 'yui/compressor'

module ::Guard
  class Mirror < Guard

    def initialize watchers = [], options = {}
      super

      @options = {
        notify: true
      }.merge options

      @env = ::Sprockets::Environment.new

      # CoffeeScript is baked into sprockets so we can skip that, but register
      # these other guys.
      @env.register_mime_type 'text/html', '.html'

      # The problem (awesomeness) with Jade is that it can export HTML or an
      # anonymous function for use as a JST. Use `.html.jade` for HTML and
      # `.jst.jade` for a jade template.
      @env.register_engine '.jade', ::Jade::Template

      @env.register_engine '.styl', ::Tilt::StylusTemplate

      # Turn on nib on demand
      Stylus.use :nib if @options[:nib]

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
        UI.info "IN -> #{path}..."
        FileUtils.mkdir_p dirname unless File.directory? dirname
        File.open(dest, 'w') do |f|
          f.write(
            begin
              @env[path]
            rescue => e
              if @options[:notify]
                Notifier.notify e.message,
                  title: 'guard-mirror',
                  image: :failed
              end
              UI.error e.message
              e.message
            end
          )
        end
        UI.info "OUT -> #{dest}"
      end
    end

    private

    def src_to_dest path
      path = path
        .sub(/\.coffee|\.jst\.jade/, '.js')
        .sub(/\.styl/, '.css')
        .sub /\.html\.jade/, '.html'
      File.expand_path "#{@options[:dest]}/#{path}"
    end

  end
end
