guard-mirror
============

A CoffeeScript, Stylus, and Jade (HTML and JST) Guard that mirrors your source
files (.coffee/.styl/.jade/.jst.jadet) in another location (public/www/etc...).

Installation
------------

    gem install guard-mirror

Configuration
-------------

In your guard file, specific a new guard with mirror as the guard name.

    guard :mirror,
      paths: ['src/js/templates', 'src/js'],
      target: 'app.coffee',
      dest: 'www',
      compress: true do
      watch %r{^src/js/(.+\..+)}
    end

TODO - MORE EXAMPLES!!!
