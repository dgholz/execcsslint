require 'rspec'
require 'csslint'

describe CSSLint do
  describe '.context' do
    subject { CSSLint.context }

    it 'returns an ExecJS context with csslint defined' do
      subject.eval('typeof CSSLint').should == 'object'
    end

    it 'returns an ExecJS context with CSSLINTR helper defined' do
      subject.eval('typeof CSSLINTR').should == 'function'
    end
  end

  describe '.run' do
    let(:context) { double(call: [[]]) }
    before { CSSLint.stub(context: context) }

    it 'lints a String of CSS' do
      context.should_receive(:call).with('CSSLINTR', 'foo', {})
      CSSLint.run('foo')
    end

    it 'lints an IO-ish of CSS' do
      ioish = Class.new { def self.read ; 'foo' ; end }
      context.should_receive(:call).with('CSSLINTR', 'foo', {})
      CSSLint.run(ioish)
    end

    it 'returns a Result object' do
      CSSLint.run('').should be_an_instance_of CSSLint::Result
    end

    it 'accepts csslint options' do
      css = '.mybox { width: 100px; margin: 1px }'
      context.should_receive(:call).with('CSSLINTR', '.mybox { width: 100px; margin: 1px }', { errors: [ 'box-model' ] } )
      CSSLint.run( '.mybox { width: 100px; margin: 1px }', { errors: [ 'box-model' ] } )
    end
  end
end

describe CSSLint::Result do
  let(:messages) {
    [{'line' => 1, 'col' => 1, 'type' => 'error', 'message' => 'FUBAR' }]
  }

  describe '#error_messages' do
    it 'returns the line/char number and reason for each error' do
      CSSLint::Result.new(messages).error_messages.should ==
        [ "1:1: [error] FUBAR" ]
    end
  end

  describe '#valid?' do
    it 'is true for problem free css' do
      CSSLint::Result.new([]).valid?.should == true
    end

    it 'is false for troublesome css' do
      CSSLint::Result.new(messages).valid?.should == false
    end
  end
end

describe 'CSSLint integration' do
  it 'knows valid css' do
    css = '.mystyle { margin: 1px }'
    CSSLint.run(css).valid?.should == true
  end

  it 'knows invalid css' do
    css = 'asd {} ()'
    CSSLint.run(css).valid?.should == false
  end

  it 'respects passed csslint options' do
    css = '.mybox { width: 100px; border: 1px }'
    CSSLint.run(css, { errors: [ 'box-model' ] }).valid?.should == false
  end
end
