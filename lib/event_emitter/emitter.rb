
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
      __event_by_ids.values
    end

    def __event_by_ids
      @__event_by_ids ||= {}
    end

    def __event_by_types
      @__event_types ||= Hash.new{|h,k| h[k] = [] }
    end

    def add_listener(type, params={}, &block)
      raise ArgumentError, 'listener block not given' unless block_given?
      type = type.to_sym
      id = @__last_event_id = (@__last_event_id||0) + 1
      e = {
        :id => id,
        :type => type,
        :type => type.to_sym,
        :listener => block,
        :params => params
      }
      __event_by_ids[id] = e
      __event_by_types[type] << e
      return id
    end

    alias :on :add_listener

    def remove_listener(id_or_type)
      if id_or_type.class == Fixnum # id
        e = __event_by_ids[id_or_type]
        return unless e
        __event_by_ids.delete id_or_type
        __event_by_types[e[:type]].delete id_or_type
      elsif [String, Symbol].include? id_or_type.class # type
        type = id_or_type.to_sym
        __event_by_types[type].each do |id|
          __event_by_ids.delete id
        end
        __event_by_types.delete type
      end
    end

    def emit(type, *data)
      type = type.to_sym
      delete_ids = []
      if type == :*
        __event_by_ids.values.each do |e|
          delete_ids.push e[:id] if e[:params][:once]
          instance_exec(e[:type], *data, &e[:listener])
        end
      else
        __event_by_types[type].each do |e|
          delete_ids.push e[:id] if e[:params][:once]
          instance_exec(*data, &e[:listener])
        end
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
