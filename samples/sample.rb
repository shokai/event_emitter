#!/usr/bin/env ruby
$:.unshift File.expand_path '../lib', File.dirname(__FILE__)
require 'event_emitter'

class User
  include EventEmitter
  attr_accessor :name

  def initialize(name)
    @name = name
  end
end

shokai = User.new 'shokai'
ymrl = User.new 'ymrl'

shokai.on :go do |data|
  puts "#{name} go to #{data[:place]}"
end
ymrl.on :go do |data|
  puts "#{name} go to #{data[:place]}"
end

shokai.emit :go, {:place => 'mountain'}
ymrl.emit :go, :place => 'cyberspace'


shokai.once :eat do |what, where|
  puts "#{name} -> #{what} at #{where}"
end

shokai.emit :eat, 'BEEF', 'zanmai'
shokai.emit :eat, 'Ramen', 'marutomo'  # do not call. call only first time if regist with "once"
