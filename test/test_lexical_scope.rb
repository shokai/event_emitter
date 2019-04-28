require File.expand_path 'test_helper', File.dirname(__FILE__)

class TestLexicalScope < MiniTest::Test

  class Foo
    include EventEmitter
  end

  class Bar
    def initialize(foo)
      @foo = foo
    end

    def reply
      'hi'
    end

    attr_accessor :response

    def setup
      @foo.on :hello do
        @response = reply
      end
    end
  end

  def setup
    @foo = Foo.new
    @bar = Bar.new(@foo)
    @bar.setup
  end

  def test_simple
    assert @bar.response == nil
    @foo.emit :hello
    assert @bar.response == @bar.reply
  end
end
