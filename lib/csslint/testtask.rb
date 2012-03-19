require 'rake'
require 'csslint'

module CSSLint
  class TestTask
    include Rake::DSL

    # Public: Gets/Sets the Array of JavaScript filenames as Strings, each of
    # which will be run through csslint. (default: Dir['**/*.css'])
    attr_accessor :file_list

    # Public: Gets/Sets the Hash of options that will be passed to each call
    # of csslint. See http://www.csslint.com/lint.html for allowed options.
    # (default: {})
    attr_accessor :options

    # Public: Define a new Rake task that runs CSSLint tests over several
    # JavaScript files.
    #
    # name - the name of the defined Rake Task. (default: 'csslint')
    #
    # Yields itself for configuration if a block is given.
    def initialize(name=:csslint)
      @name = name
      @file_list = Dir['**/*.css']
      @options   = {}
      yield self if block_given?

      define_task
    end

    # Internal: Define the actual Rake task.
    def define_task
      desc "Run #{@name == :csslint ? '' : @name + ' '}CSSLint tests"
      task @name do
        t0 = Time.now
        errors = []

        @file_list.each do |f|
          result = CSSLint.run(File.open(f), @options )
          if result.valid?
            print '.'
          else
            errors << result.error_messages.map {|e| "#{f}:#{e}"}
            print 'F'
          end
        end

        puts
        puts
        if errors.any?
          puts *errors
          puts
        end
        puts "Finished in %.5f seconds" % [Time.now.to_f - t0.to_f]
        puts "%d files, %d errors"      % [@file_list.length, errors.length]
      end
    end

  end
end
