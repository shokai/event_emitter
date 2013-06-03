require File.expand_path 'test_helper', File.dirname(__FILE__)

class TestEventEmitter < MiniTest::Test

  class Foo
    include EventEmitter
    attr_accessor :created_at
  end

  def setup
    @foo = Foo.new
    @foo.created_at = @now = Time.now
  end

  def test_simple
    created_at = nil
    @foo.on :bar do
      created_at = self.created_at
    end
    @foo.emit :bar

    assert created_at == @now
  end

  def test_string_event_name
    created_at = nil
    @foo.on "bar" do
      created_at = self.created_at
    end
    @foo.emit :bar
  end

  def test_on_emit
    result = nil
    created_at = nil
    @foo.on :chat do |data|
      result = data
      created_at = self.created_at
    end

    @foo.emit :chat, :user => 'shokai', :message => 'hello world'

    assert result[:user] == 'shokai'
    assert result[:message] == 'hello world'
    assert created_at == @now, 'instance method'
  end

  def test_on_emit_multiargs
    _user = nil
    _message = nil
    _session = nil
    created_at = nil
    @foo.on :chat do |user, message, session|
      _user = user
      _message = message
      _session = session
      created_at = self.created_at
    end

    sid = Time.now.to_i
    @foo.emit :chat, 'shokai', 'hello world', sid

    assert _user == 'shokai'
    assert _message == 'hello world'
    assert _session == sid
    assert created_at == @now, 'instance method'
  end

  def test_add_listener
    result = nil
    created_at = nil
    @foo.add_listener :chat do |data|
      result = data
      created_at = self.created_at
    end

    @foo.emit :chat, :user => 'shokai', :message => 'hello world'

    assert result[:user] == 'shokai'
    assert result[:message] == 'hello world'
    assert created_at == @now, 'instance method'
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

    assert @foo.__events.size == 3, 'check registerd listener count'
    @foo.remove_listener id
    assert @foo.__events.size == 2, 'remove listener by id'

    @foo.remove_listener :bar
    assert @foo.__events.size == 0, 'remove all "bar" listener'
  end

  def test_once
    total = 0
    @foo.once :add do |num|
      total += num
    end

    @foo.emit :add, 1
    assert total == 1, 'first call'
    @foo.emit :add, 1
    assert total == 1, 'call listener only first time'
  end

  def test_multiple_once
    total = 0
    @foo.on :add do |num|
      total += num
    end

    @foo.once :add do |num|
      total += num
    end

    @foo.once :add do |num|
      total += num
    end

    @foo.once :add do |num|
      total += num
    end

    @foo.once :add do |num|
      total += num
    end

    @foo.emit :add, 1
    assert total == 5, 'first call'
    @foo.emit :add, 1
    assert total == 6, 'call'
  end
end
