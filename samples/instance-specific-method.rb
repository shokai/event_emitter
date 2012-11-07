#!/usr/bin/env ruby
$:.unshift File.expand_path '../lib', File.dirname(__FILE__)
require 'event_emitter'

class User
  attr_accessor :name
  def initialize(name)
    @name = name
  end
end

shokai = User.new "shokai"
ymrl = User.new "ymrl"
EventEmitter.apply shokai ## set instance-specific method

shokai.on :go do |data|
  puts "#{name} go to #{data[:place]}"
end

shokai.emit :go, :place => "chiba city"

## raise undefined-method error
begin
  ymrl.on :go do |data|
    puts "#{name} go to #{data[:place]}"
  end
rescue => e
  STDERR.puts e
end
