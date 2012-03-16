ExecCSSLint
==========

ExecCSSLint is a thin Ruby wrapper that uses ExecJS to execute [csslint].

Install
-------

```
$ gem install execcsslint
```

Usage
-----

```ruby
js = File.open('path/to/my.js')
results = csslint.run(js)
if result.valid?
  puts "Great job pal"
else
  puts "Check your CSS"
  puts result.errors
end
```

If you're looking to use this in a Rails app, take a look at
[examples/csslint.rake][rake].

Requirements
------------

You'll need one of the [supported ExecJS runtimes][execjs-runtimes]. OS X
comes with JavaScriptCore by default, so you likely don't need to install
anything.

csslint Options
--------------

Right now, `ExecCSSLint` does not support setting global csslint options, so you'll
have to include them in a `/*csslint */` comment at the top of each file.
`csslint.js` will automatically parse and apply options specified like this. A
full list of options is available on [csslint.net][csslint-options].

Using an Alternate csslint.js
----------------------------

ExecCSSLint depends on the `csslint-source` gem, which is a ruby packaging
of the official [csslint.js][csslintjs]. By default, ExecCSSLint depends on the
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
