#!/usr/bin/env ruby
$:.unshift File.expand_path '../lib', File.dirname(__FILE__)
require 'event_emitter'

class DB
  def self.connect
    self.emit :connect, :connected
  end
end

EventEmitter.apply DB

DB.on :connect do |status|
  puts status
end

DB.connect
