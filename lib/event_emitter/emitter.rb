
module EventEmitter
  def self.included(klass)
    klass.extend ClassMethods
    klass.__send__ :include, InstanceMethods
  end

  def self.apply(object)
    object.extend InstanceMethods
  end

  module ClassMethods
  end

  module InstanceMethods
    def events
      @events ||= []
    end

    def add_listener(type, params={}, &block)
      raise ArgumentError, 'listener block not given' unless block_given?
      id = events.empty? ? 0 : events.last[:id]+1
      events << {
        :type => type.to_sym,
        :listener => block,
        :params => params,
        :id => id
      }
      id
    end

    alias :on :add_listener

    def remove_listener(id_or_type)
      if id_or_type.class == Fixnum
        events.delete_if do |e|
          e[:id] == id_or_type
        end
      elsif [String, Symbol].include? id_or_type.class
        events.delete_if do |e|
          e[:type] == id_or_type.to_sym
        end
      end
    end

    def emit(type, data=nil)
      events.each do |e|
        if e[:type] == type.to_sym
          listener = e[:listener]
          remove_listener e[:id] if e[:params][:once]
          instance_exec(data, &listener)
        end
      end
    end

    def once(type, &block)
      add_listener type, {:once => true}, &block
    end

  end

end
