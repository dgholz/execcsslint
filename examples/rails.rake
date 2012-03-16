begin
  require 'csslint/testtask'

  CSSLint::TestTask.new do |t|
    t.file_list = Dir['{app,lib}/assets/css/**/*.css']
    t.options = {
       # ...
    }
  end
  Rake::Task[:test].enhance(['jslint'])
rescue LoadError
  # CSSLint not loaded (eg, in production). Oh well.
end
