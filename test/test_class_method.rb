require File.expand_path 'test_helper', File.dirname(__FILE__)

class TestClassMethod < MiniTest::Test

  class Foo
    def self.created_at
      @@created_at
    end
    def self.created_at=(time)
      @@created_at = time
    end
  end

  def setup
    Foo.created_at = @now = Time.now
    EventEmitter.apply Foo
  end

  def test_simple
    created_at = nil
    Foo.on :bar do
      created_at = self.created_at
    end
    Foo.emit :bar

    assert created_at == @now
  end

  def test_on_emit
    result = nil
    created_at = nil
    Foo.on :chat do |data|
      result = data
      created_at = self.created_at
    end

    Foo.emit :chat, :user => 'shokai', :message => 'hello world'

    assert result[:user] == 'shokai'
    assert result[:message] == 'hello world'
    assert created_at == @now, 'instance method'
  end

  def test_on_emit_multiargs
    _user = nil
    _message = nil
    _session = nil
    created_at = nil
    Foo.on :chat2 do |user, message, session|
      _user = user
      _message = message
      _session = session
      created_at = self.created_at
    end

    sid = Time.now.to_i
    Foo.emit :chat2, 'shokai', 'hello world', sid

    assert _user == 'shokai'
    assert _message == 'hello world'
    assert _session == sid
    assert created_at == @now, 'instance method'
  end

  def test_add_listener
    result = nil
    created_at = nil
    Foo.add_listener :chat do |data|
      result = data
      created_at = self.created_at
    end

    Foo.emit :chat, :user => 'shokai', :message => 'hello world'

    assert result[:user] == 'shokai'
    assert result[:message] == 'hello world'
    assert created_at == @now, 'instance method'
  end

  def test_remove_listener
    size = Foo.__events.size

    Foo.on :foo do |data|
      puts "bar #{data}"
    end
    Foo.on :foo do |data|
      puts "barbar: #{data}"
    end

    id = Foo.on :baz do |data|
      p data
    end

    assert Foo.__events.size == size+3, 'check registerd listener count'
    Foo.remove_listener id
    assert Foo.__events.size == size+2, 'remove listener by id'

    Foo.remove_listener :foo
    assert Foo.__events.size == size, 'remove all "foo" listener'
  end

  def test_once
    total = 0
    Foo.once :add do |data|
      total += data
    end

    Foo.emit :add, 1
    assert total == 1, 'first call'
    Foo.emit :add, 1
    assert total == 1, 'call listener only first time'
  end
end
