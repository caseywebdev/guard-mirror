guard-mirror
============

A CoffeeScript, Stylus, and Jade (HTML and JST) Guard that mirrors your source
files (.coffee/.styl/.jade/.jst.jadet) in another location (public/www/etc...).

I created this to help with Cordova development and it's working out really nice!

Installation
------------

In your `Gemfile`...

    source :rubygems

    gem install guard-mirror

Configuration
-------------

In your `Guardfile`...

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

Running It
----------

    bundle update
    bundle --binstubs
    bin/guard

Profit!
