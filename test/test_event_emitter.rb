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
      result = data
    end

    @foo.emit :chat, :user => 'shokai', :message => 'hello world'

    assert result[:user] == 'shokai'
    assert result[:message] == 'hello world'
  end

  def test_add_listener
    result = nil
    @foo.add_listener :chat do |data|
      result = data
    end

    @foo.emit :chat, :user => 'shokai', :message => 'hello world'

    assert result[:user] == 'shokai'
    assert result[:message] == 'hello world'
  end

  def test_remove_listener
    @foo.on :bar do |data|
      puts "bar #{data}"
    end
    @foo.on :bar do |data|
      puts "barbar: #{data}"
    end

    id = @foo.on :baz do |data|
      p data
    end

    assert @foo.events.size == 3, 'check registerd listener count'
    @foo.remove_listener id
    assert @foo.events.size == 2, 'remove listener by id'

    @foo.remove_listener :bar
    assert @foo.events.size == 0, 'remove all "bar" listener'
  end
end
