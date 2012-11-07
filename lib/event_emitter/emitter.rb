
module EventEmitter
  def self.included(klass)
    klass.extend ClassMethods
    klass.__send__ :include, InstanceMethods
  end

  module ClassMethods
  end

  module InstanceMethods
    def events
      @events ||= []
    end

    def add_listener(type, &block)
      raise ArgumentError, 'listener block not given' unless block_given?
      events << {:type => type.to_sym, :listener => block}
    end

    alias :on :add_listener
    
    def emit(type, data)
      events.each do |e|
        e[:listener].call data if e[:type] == type.to_sym
      end
    end

  end

end
