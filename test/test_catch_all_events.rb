require File.expand_path 'test_helper', File.dirname(__FILE__)

class TestCatchAllEvents < MiniTest::Test

  class Foo
    include EventEmitter
    attr_accessor :created_at
  end

  def setup
    @foo = Foo.new
    @foo.created_at = @now = Time.now
  end

  def test_catch_all_emits
    created_at = nil
    created_at_ = nil
    called_event = nil
    @foo.on :* do |event|
      called_event = event
      created_at = self.created_at
    end
    @foo.on :bar do
      created_at_ = self.created_at
    end
    @foo.emit :bar

    assert created_at == @now
    assert called_event == :bar
    assert created_at_ == @now
  end

  def test_catch_all_emits_with_args
    arg1_ = nil
    arg2_ = nil
    called_event = nil
    @foo.on :* do |event, arg1, arg2|
      called_event = event
      arg1_ = arg1
      arg2_ = arg2
    end
    @foo.emit :bar, 'kazusuke', 'zanmai'

    assert called_event == :bar
    assert arg1_ == 'kazusuke'
    assert arg2_ == 'zanmai'
  end

  def test_once
    total = 0
    @foo.once :* do |event, data|
      total += data[:num] if event == :add
    end

    @foo.emit :add, :num => 10
    assert total == 10, 'first call'
    @foo.emit :add, :num => 5
    assert total == 10, 'call listener only first time'
  end

end
