Gem::Specification.new do |s|
  s.name      = 'execcsslint'
  s.version   = '12.03.16'
  s.date      = '2012-03-16'

  s.homepage    = "http://github.com/dgholz/execcsslint"
  s.summary     = "ExecJS CSSLint Bridge"
  s.description = <<-EOS
    A bridge to run CSSLint from Ruby via ExecJS.
  EOS

  s.files = [
    'lib/execcsslint.rb',
    'lib/csslint.rb',
    'lib/csslint/testtask.rb',
    'LICENSE',
    'README.md'
  ]

  s.add_dependency 'rake', '>= 0.8.7'
  s.add_dependency 'csslint-source'
  s.add_dependency 'execjs'
  s.add_development_dependency 'rspec'

  s.authors = ['Dean Strelau', 'Daniel Holz']
  s.email   = 'dgholz@gmail.com'
end
