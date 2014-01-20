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

    def deterministic?
      counter = transitions.each_with_object(Hash.new{|key| 0 }) do |transition, counter|
        key = [transition.src, transition.symbol]
        counter[key] += 1
      end

      counter.values.all? {|count| count == 1 }
    end

    def with_epsilon?
      transitions.any? {|transition| transition.symbol == nil }
    end

    def drives(from, symbol)
      transitions.each_with_object(Set.new) do |transition, set|
        if transition.src == from and transition.symbol == symbol
          set << transition.dest
        end
      end
    end

    def self.compile_regex(regex, factory: StateFactory.new)
      nfa = NFA.new()

      
    end

    def self.dfa_from_nfa(nfa)
      dfa = FSA.new
      dfa.start = Set.new([nfa.start])
      dfa.states << dfa.start

      queue = [dfa.start]
      until queue.empty?
        from = queue.shift
        destinations = Hash.new {|hash, key| hash[key] = Set.new }

        nfa.transitions.select {|transition| from.include? transition.src }.each {|transition|
          destinations[transition.symbol] << transition.dest
        }

        destinations.each do |symbol, destination|
          dfa.transitions << Transition.new(symbol, from, destination)

          unless dfa.states.include?(destination)
            dfa.states << destination
            queue << destination
          end
        end
      end

      dfa.states.each do |state|
        if state.intersection(nfa.acceptings).size > 0
          dfa.acceptings << state
        end
      end

      dfa
    end
	end
end
