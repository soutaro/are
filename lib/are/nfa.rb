require "set"

module ARE
  class Transition
    attr_reader :symbol
    attr_reader :src
    attr_reader :dest

    def initialize(symbol, src, dest)
      @symbol = symbol
      @src = src
      @dest = dest
    end

    def inspect
      "#<Transition: (#{self.symbol.inspect}) #{self.src.inspect} => #{self.dest.inspect}>"
    end
  end

  class StateFactory
    def initialize(prefix = "s")
      @prefix = prefix
      @counter = 0
    end

    def next
      state = :"#{@prefix}#{@counter}"
      @counter += 1
      state
    end
  end

	class FSA
    attr_reader :states
    attr_reader :transitions
    attr_accessor :start
    attr_reader :acceptings

    def initialize()
      @states = Set.new
      @transitions = Set.new
      @start = nil
      @acceptings = Set.new
    end

    def inspect
      "#<NFA: states={#{self.states.to_a.map(&:inspect).join(', ')}}, transitions={#{self.transitions.to_a.map(&:inspect).join(', ')}}, start=#{self.start.inspect}, acceptings={#{self.acceptings.to_a.map(&:inspect).join('. ')}}>"
    end

    def nfa?
      type == :nfa
    end

    def dfa?
      type == :dfa
    end

    def type
      # Epsilon transition means NFA
      return :nfa if transitions.any? {|transition| transition.symbol == nil }

      counter = transitions.each_with_object(Hash.new{|key| 0 }) do |transition, counter|
        key = [transition.src, transition.symbol]
        counter[key] += 1
      end

      if counter.values.any? {|count| count > 1 }
        :nfa
      else
        :dfa
      end
    end

    def self.compile_regex(regex, factory: StateFactory.new)
      nfa = NFA.new()

      
    end
	end
end
