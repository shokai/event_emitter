
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
    def __events
      @__events ||= Hash.new{|h,k| h[k] = [] }
    end

    def add_listener(type, params={}, &block)
      raise ArgumentError, 'listener block not given' unless block_given?
      id = (@__events_last_id ||= -1)+1
      __events[type.to_sym] << {
        :listener => block,
        :params => params,
        :id => id
      }
      id
    end

    alias :on :add_listener

    def remove_listener(id_or_type)
      if id_or_type.class == Fixnum
        __events.values.each do |events|
          events.delete_if do |e|
            e[:id] == id_or_type
          end
        end
      elsif [String, Symbol].include? id_or_type.class
        __events.delete id_or_type.to_sym
      end
    end

    def emit(type, *data)
      delete_ids = []
      __events[type.to_sym].each do |e|
        listener = e[:listener]
        delete_ids.push e[:id] if e[:params][:once]
        instance_exec(*data, &listener)
      end
      __events[:*].each do |e|
        listener = e[:listener]
        delete_ids.push e[:id] if e[:params][:once]
        instance_exec(type, *data, &listener)
      end
      delete_ids.each do |id|
        remove_listener id
      end
    end

    def once(type, &block)
      add_listener type, {:once => true}, &block
    end

  end

end
