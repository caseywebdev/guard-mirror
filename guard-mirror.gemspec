Gem::Specification.new do |s|
  s.name        = 'guard-mirror'
  s.version     = '1.0.0'
  s.date        = '2012-06-07'
  s.summary     = 'Mirror .coffee, .styl, and .jade as .js, .css, and .html'
  s.author     = 'Casey Foster'
  s.email       = 'nick@quaran.to'
  s.files       = Dir['lib/**/*.rb']
  s.homepage    = 'https://github.com/caseywebdev/guard-mirror'

  s.description = <<-EOF
    A CoffeeScript, Stylus, and Jade (HTML and JST) Guard that mirrors
    yoursource files (.coffee/.styl/.jade/.jst.jadet) in another location
    (public/www/etc...).
  EOF

  s.required_ruby_version = '>= 1.9.2'
  s.add_runtime_dependency 'guard'
  s.add_runtime_dependency 'sprockets'
  s.add_runtime_dependency 'coffee-script'
  s.add_runtime_dependency 'jade'
  s.add_runtime_dependency 'stylus'
  s.add_runtime_dependency 'closure-compiler'
  s.add_runtime_dependency 'yui-compressor'
  s.add_runtime_dependency 'json'
end
