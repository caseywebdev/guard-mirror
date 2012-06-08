guard-mirror
============

A CoffeeScript, Stylus, and Jade (HTML and JST) Guard that mirrors your source
files (.coffee/.styl/.jade/.jst.jadet) in another location (public/www/etc...).
guard-mirror also can compress the files on the fly for use in production with
a simple `compress: true` option. Google Closure Compiler is used for JS and
YUI Compressor for CSS. Jade -> HTML files are automatically shrinkwrapped.

I created this to help with PhoneGap/Cordova development and it's working out really nice!

Installation
------------

In your `Gemfile`...

```ruby
source :rubygems

gem 'guard-mirror'
# Optionally a notifier like Growl.
# Syntax/parse errors will be displayed
# in notifications which becomes very
# handy!
# gem 'growl'
```

Configuration
-------------

In your `Guardfile`...

```ruby
guard :mirror,
    paths: ['src/js/templates', 'src/js'],
    target: 'app.coffee',
    dest: 'www',
    compress: true do
  watch %r{^src/js/(.+\..+)}
end

guard :mirror,
    paths: ['src/css'],
    target: 'app.styl',
    dest: 'www',
    compress: true do
  watch %r{^src/css/(.+\..+)}
end

guard :mirror,
    paths: ['src/html'],
    dest: 'www' do
  watch(%r{^src/html/(.+\..+)}) { |m| m[1] }
end
```

Running It
----------

```bash
bundle update
bundle --binstubs
bin/guard
```

Profit!
