require File.expand_path 'test_helper', File.dirname(__FILE__)

class TestEventEmitter < MiniTest::Unit::TestCase

  class Foo
    include EventEmitter
  end

  def setup
    @foo = Foo.new
  end
  
  def test_on_emit
    result = nil
    @foo.on :chat do |data|
      puts "chat - #{data[:user]} : #{data[:message]}"
      result = data
    end

    @foo.emit :chat, :user => 'shokai', :message => 'hello world'

    assert result[:user] == 'shokai'
    assert result[:message] == 'hello world'
  end
end
