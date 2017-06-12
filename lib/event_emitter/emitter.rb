
module EventEmitter
  def self.included(klass)
    # klass.extend ClassMethods
    klass.__send__ :include, InstanceMethods
  end

  def self.apply(object)
    object.extend InstanceMethods
  end

  module ClassMethods
  end

  module InstanceMethods
    def __events
      @__events ||= []
    end

    def add_listener(type, params={}, &block)
      raise ArgumentError, 'listener block not given' unless block_given?
      id = __events.empty? ? 0 : __events.last[:id]+1
      __events << {
        :type => type.to_sym,
        :listener => block,
        :params => params,
        :id => id
      }
      id
    end

    alias :on :add_listener

    def remove_listener(id_or_type)
      if id_or_type.is_a? Integer
        __events.delete_if do |e|
          e[:id] == id_or_type
        end
      elsif [String, Symbol].include? id_or_type.class
        __events.delete_if do |e|
          e[:type] == id_or_type.to_sym
        end
      end
    end

    def emit(type, *data)
      type = type.to_sym
      __events.each do |e|
        case e[:type]
        when type
          listener = e[:listener]
          e[:type] = nil if e[:params][:once]
          instance_exec(*data, &listener)
        when :*
          listener = e[:listener]
          e[:type] = nil if e[:params][:once]
          instance_exec(type, *data, &listener)
        end
      end
      __events.each do |e|
        remove_listener e[:id] unless e[:type]
      end
    end

    def once(type, &block)
      add_listener type, {:once => true}, &block
    end

  end

end
