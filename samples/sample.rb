#!/usr/bin/env ruby
$:.unshift File.expand_path '../lib', File.dirname(__FILE__)
require 'event_emitter'

class Foo
  include EventEmitter
  attr_accessor :created_at
end

foo = Foo.new
foo.created_at = Time.now

foo.on 'chat' do |data|
  puts "chat - #{data[:user]} : #{data[:message]} at #{created_at}"
end

foo.on :sum do |data|
  puts data.inject{|a,b|
    a+b
  }
end

foo.once :bar do |data|
  puts "hello #{data} at #{created_at}"
end

foo.emit 'chat', {:user => 'shokai', :message => 'hello world'}
foo.emit :chat, :user => 'ymrl', :message => 'hello work'

foo.emit :sum, [1,2,3,45]

foo.emit :bar, 'shokai'
foo.emit :bar, 'shooooookai' # not call
