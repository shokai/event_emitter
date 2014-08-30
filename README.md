event_emitter
=============

* Ruby port of EventEmitter from Node.js
* http://shokai.github.com/event_emitter

[![Build Status](https://travis-ci.org/shokai/event_emitter.svg)](https://travis-ci.org/shokai/event_emitter)


Install
-------

    % gem install event_emitter


Requirements
------------

testing on

* Ruby 1.8.7
* Ruby 1.9.2
* Ruby 2.0.0
* Ruby 2.1.0
* JRuby


Synopsys
--------

load rubygem
```ruby
require "rubygems"
require "event_emitter"
```

include
```ruby
class User
  include EventEmitter
  attr_accessor :name
end
```

regist event listener
```ruby
user = User.new
user.name = "shokai"
user.on :go do |data|
  puts "#{name} go to #{data[:place]}"
end
```

call event
```ruby
user.emit :go, {:place => "mountain"}
# => "shokai go to mountain"
```

regist event using "once"
```ruby
user.once :eat do |what, where|
  puts "#{name} -> eat #{what} at #{where}"
end
```

call
```ruby
user.emit :eat, "BEEF", "zanmai"  # =>  "shokai -> eat BEEF at zanmai"
user.emit :eat, "Ramen", "marutomo"  # => do not call. call only first time.
```

apply as instance-specific method
```ruby
class Foo
end

foo = Foo.new
EventEmitter.apply foo
```

remove event listener
```ruby
user.remove_listener :go
user.remove_listener event_id
```

catch all events
```ruby
user.on :* do |event_name, args|
  puts event_name + " called"
  p args
end
```

see samples https://github.com/shokai/event_emitter/tree/master/samples


Test
----

    % gem install bundler
    % bundle install
    % rake test


Benchmark
---------

    % rake benchmark


Contributing
------------
1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request