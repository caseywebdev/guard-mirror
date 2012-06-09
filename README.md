guard-mirror
============

A CoffeeScript, Stylus, and Jade (HTML and JST) Guard that mirrors your source
files (.coffee/.styl/.jst.jade/.html.jade) in another location
(public/www/etc...). guard-mirror also can compress the files on the fly for
use in production with a simple `compress: true` option. Google Closure
Compiler is used for JS and YUI Compressor for CSS. Jade -> HTML files are
automatically shrinkwrapped. Sprockets is used for file requiring and
concatination so all of the same Sprockets syntax can be used.

I created this to help with PhoneGap/Cordova development and it's working out really nice!

Installation
------------

In your `Gemfile`...

```ruby
source :rubygems

gem 'guard-mirror'
# Optionally a notifier like Growl. Syntax/parse errors will be displayed in
# notifications which becomes very handy!
# Use the `notify: false` option to turn this off
# gem 'growl'
```

If you want to use nib, you'll have to have the module installed. I recommend adding a `package.json` file to your root directory with something like...

```json
{
  "name": "app-name",
  "version": "0.0.1",
  "author": "Your Name <you@example.com>",
  "dependencies": [
    "coffee-script",
    "stylus",
    "nib",
    "jade"
  ]
}
```

And then running...

```bash
cd to/your/root
npm install
```

Configuration
-------------

In your `Guardfile`...

```ruby
guard :mirror,
    paths: ['src/js/templates', 'src/js'],
    # If a target is specified, only this file will be compiled when any
    # watched file changes.
    target: 'app.coffee',
    dest: 'www',
    compress: true do
  watch %r{^src/js/(.+\..+)}
end

guard :mirror,
    paths: ['src/css'],
    target: 'app.styl',
    dest: 'www',
    # nib is supported with this flag
    nib: true,
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
