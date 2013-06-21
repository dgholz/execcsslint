ExecCSSLint
==========

ExecCSSLint is a thin Ruby wrapper that uses ExecJS to execute [csslint]. It is heavily inspired by Dean Strelau's [https://github.com/mintdigital/execjslint](ExecJSLint).

Install
-------

```
$ gem install execcsslint
```

Usage
-----

```ruby
require 'execcsslint'

css = File.open('path/to/my.css')
results = CSSLint.run(css)
if !result.valid?
  # There were errors
  puts "Check your CSS"
  puts result.error_messages
elsif !result.error_messages.empty?
  # There were warnings
  puts "You may want to take at look at your CSS"
  puts result.error_messages
else
  puts "Great job pal"
end
```

`CSSLint.run` accepts an IO object (that responds to `read()`) or a string.

If you're looking to use this in a Rails app, take a look at
[examples/csslint.rake](the example rake task).

Requirements
------------

You'll need one of the [execjs-runtimes](supported ExecJS runtimes). OS X
comes with JavaScriptCore by default, so you likely don't need to install
anything.

csslint Options
--------------

Right now, `ExecCSSLint` does not support setting global csslint options, so you'll
have to include them in a `/*csslint */` comment at the top of each file.
`csslint.js` will automatically parse and apply options specified like this. A
full list of options is available on [csslint.net].

Using an Alternate csslint.js
----------------------------

ExecCSSLint depends on the `csslint-source` gem, which is a ruby packaging
of the official csslint.js. By default, ExecCSSLint depends on the
latest version of the `csslint-source` gem. As there are no official releases
of csslint, `csslint-source` is versioned according to [the date at the top of
csslint.js][csslint-date] (eg, `2012.03.16`). rubygems.org has a [full list of
`csslint-source` gem versions][source-versions].

To override this, you can specify an explicit dependency on `csslint-source`,
for example, using bundler:

```
gem 'execcsslint'
gem 'csslint-source', '2012.03.17'
```

You can also explicitly specify a local copy of `csslint.js` to use by setting
the `CSSLINT_PATH` env variable.

```
$ CSSLINT_PATH=../lib/csslint.js rake csslint
```
