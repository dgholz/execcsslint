require 'rspec'
require 'csslint'

describe CSSLint do
  describe '.context' do
    subject { CSSLint.context }

    it 'returns an Execcss context with csslint defined' do
      subject.eval('typeof csslint').should == 'function'
    end

    it 'returns an Execcss context with csslintR helper defined' do
      subject.eval('typeof csslintR').should == 'function'
    end
  end

  describe '.run' do
    let(:context) { double(call: [true,[]]) }
    before { CSSLint.stub(context: context) }

    it 'lints a String of css' do
      context.should_receive(:call).with('csslintR', 'foo', {})
      CSSLint.run('foo')
    end

    it 'lints an IO-ish of css' do
      ioish = Class.new { def self.read ; 'foo' ; end }
      context.should_receive(:call).with('csslintR', 'foo', {})
      CSSLint.run(ioish)
    end

    it 'returns a Result object' do
      CSSLint.run('').should be_an_instance_of CSSLint::Result
    end

    it 'accepts csslint options' do
      context.should_receive(:call).with('csslintR', 'foo', {sloppy: true})
      CSSLint.run('foo', sloppy: true)
    end
  end
end

describe CSSLint::Result do
  let(:errors) {
    [{'line' => 1, 'character' => 1, 'reason' => 'FUBAR' }]
  }

  describe '#error_messages' do
    it 'returns the line/char number and reason for each error' do
      CSSLint::Result.new(false, errors).error_messages.should ==
        [ "1:1: FUBAR" ]
    end
  end

  describe '#valid?' do
    it 'is true for problem free css' do
      CSSLint::Result.new(true,[]).valid?.should == true
    end

    it 'is false for troublesome css' do
      CSSLint::Result.new(false,errors).valid?.should == false
    end
  end
end

describe 'CSSLint integration' do
  it 'knows valid css' do
    css = 'function one() { "use strict"; return 1; }'
    CSSLint.run(css).valid?.should == true
  end

  it 'knows invalid css' do
    css = "function one() { return 1 }"
    CSSLint.run(css).valid?.should == false
  end

  it 'respects inline csslint options' do
    css = "/*csslint  sloppy: true */\nfunction one() { return 1; }"
    CSSLint.run(css).valid?.should == true
  end

  it 'respects passed csslint options' do
    css = "function one() { return 1; }"
    CSSLint.run(css, sloppy: true).valid?.should == true
  end
end
