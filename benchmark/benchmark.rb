#!/usr/bin/env ruby
require File.expand_path 'benchmark_helper', File.dirname(__FILE__)

class Bench

  class Foo
    include EventEmitter
  end

  def bench_1on_100Kemit
    foo = Foo.new
    count = 0
    foo.on :bar do |num|
      count += num
    end
    100000.times do
      foo.emit :bar, 1
    end
    raise Error, "test code error" unless count == 100000
  end

  def bench_1Kon_1Kemit
    foo = Foo.new
    count = 0
    (1000-1).times do
      foo.on :bar do
      end
    end
    foo.on :bar do |num|
      count += num
    end
    1000.times do
      foo.emit :bar, 1
    end
    raise Error, "test code error" unless count == 1000
  end

  def bench_100Kon_1emit
    foo = Foo.new
    count = 0
    1.upto(100000-1).each do |i|
      foo.on "bar_#{i}" do
      end
    end
    foo.on :bar do |num|
      count += num
    end
    foo.emit :bar, 1
    raise Error, "test code error" unless count == 1
  end

end


if __FILE__ == $0
  Bench.run
end
