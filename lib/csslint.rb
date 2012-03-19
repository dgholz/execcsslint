require 'execjs'
require 'csslint/source'

module CSSLint
  # Internal: The ExecJS Context in which to run csslint().
  #
  # Provides a small helper function CSSLINTR to return both the CSSLint()
  # return value and the CSSLint messages
  def self.context
    ExecJS.compile(
      CSSLint::Source.contents + <<-EOW

function gatherRules(options){
    var ruleset,
        warnings = options.rules || options.warnings,
        errors = options.errors;
    
    if (warnings){
        ruleset = ruleset || {};
        for( var _i = 0, _len = warnings.length; _i < _len; _i++ ) {
            ruleset[warnings[_i]] = 1;
        };
    }
    
    if (errors){
        ruleset = ruleset || {};
        for( var _i = 0, _len = errors.length; _i < _len; _i++ ) {
            ruleset[errors[_i]] = 2;
        };
    }
    
    return ruleset;
}

function CSSLINTR(source, options) {
    var result    = CSSLint.verify( source, gatherRules( options ) );
    var messages  = result.messages || [];
    return [ messages ];
};
      EOW
    )
  end

  # Public: Run CSSLint over some CSS text
  #
  # source - some String-like or IO-like CSS text
  # options - Hash of options passed directly to csslint (default: {})
  def self.run(source, options={})
    source   = source.respond_to?(:read) ? source.read : source
    if source.respond_to?(:path)
      options[:fullPath] = File.expand_path( source.path )
      options[:filename] =                   source.path
    end
    Result.new(*context.call("CSSLINTR", source, options))
  end

  class Result
    def initialize(messages)
      @messages = messages
    end

    # Public: Did the CSS text pass CSSLint without messages?
    #
    # This is the return value of the CSSLint() function.
    #
    # Returns true iff CSSLint returned no error messages.
    def valid?
      @messages.select { |m| m['type'] == 'error' }.length == 0
    end

    # Public: A nicely formatted list of messages with their line number.
    #
    # Returns an Array of Strings.
    def error_messages
      # @messages may have a 'nil' as the last element if there was a catastrophic
      # error, so we 'compact'.
      @messages.compact.map {|e|
        "#{e['line']}:#{e['col']}: [#{ e['type'] }] #{e['message']}#{ e['evidence'] and " (#{ e['evidence'] })"}"
      }
    end
  end
end
