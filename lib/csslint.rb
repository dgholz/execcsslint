require 'execjs'
require 'csslint/source'

module CSSLint
  # Internal: The ExecJS Context in which to run csslint().
  #
  # Provides a small helper function csslintR to return both the csslint()
  # return value and the csslint.errors object.
  def self.context
    ExecJS.compile(
      CSSLint::Source.contents +
      "function csslintR(source, options) { " +
      "return [csslint(source, options),csslint.errors]; };"
    )
  end

  # Public: Run CSSLint over some CSS text
  #
  # source - some String-like or IO-like CSS text
  # options - Hash of options passed directly to csslint (default: {})
  def self.run(source, options={})
    source = source.respond_to?(:read) ? source.read : source
    Result.new(*context.call("csslintR", source, options))
  end

  class Result
    def initialize(valid, errors)
      @valid = valid
      @errors = errors
    end

    # Public: Did the CSS text pass CSSLint without errors?
    #
    # This is the return value of the csslint() function.
    #
    # Returns true iff CSSLint found no errors.
    def valid?
      @valid
    end

    # Public: A nicely formatted list of errors with their line number.
    #
    # Returns an Array of Strings.
    def error_messages
      # @errors will have a 'nil' last element if csslint it hit a catastrophic
      # error before it finished looking at the whole file, so we 'compact'.
      @errors.compact.map {|e|
        "#{e['line']}:#{e['character']}: #{e['reason']}"
      }
    end
  end
end
