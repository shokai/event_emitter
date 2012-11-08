require File.expand_path 'test_helper', File.dirname(__FILE__)

class TestSingularMethod < MiniTest::Unit::TestCase

  class Foo
    attr_accessor :created_at
  end

  def setup
    @foo = Foo.new
    @foo.created_at = @now = Time.now
    EventEmitter.apply @foo
  end

  def test_simple
    created_at = nil
    @foo.on :bar do
      created_at = self.created_at
    end
    @foo.emit :bar

    assert created_at == @now
  end
  
  def test_on_emit
    result = nil
    __created_at = nil
    @foo.on :chat do |data|
      result = data
      __created_at = created_at
    end

    @foo.emit :chat, :user => 'shokai', :message => 'hello world'

    assert result[:user] == 'shokai'
    assert result[:message] == 'hello world'
    assert __created_at == @now, 'instance method'
  end

  def test_add_listener
    result = nil
    __created_at = nil
    @foo.add_listener :chat do |data|
      result = data
      __created_at = created_at
    end

    @foo.emit :chat, :user => 'shokai', :message => 'hello world'

    assert result[:user] == 'shokai'
    assert result[:message] == 'hello world'
    assert __created_at == @now, 'instance method'
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

  def test_once
    total = 0
    @foo.once :add do |data|
      total += data
    end

    @foo.emit :add, 1
    assert total == 1, 'first call'
    @foo.emit :add, 1
    assert total == 1, 'call listener only first time'
  end
end
