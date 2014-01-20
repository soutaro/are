require "are/automaton"

module ARE
  class Regexp
    def =~(other)
    end

    attr_reader :kind, :args

    def initialize(kind, args = nil)
      @kind = kind
      @args = args
    end

    def +(other)
      ARE.concat(self, other)
    end

    def |(other)
      ARE.alt(self, other)
    end

    def star(min = 0, max = nil)
      Regexp.new(:star, self, min, max)
    end

    def maybe
      self.star(0,1)
    end
  end

  module_function

  def concat(*args)
    Regexp.new(:concat, args)
  end

  def alt(*args)
    Regexp.new(:alt, args)
  end

  def empty
    Regexp.new(:empty)
  end

  def any
    Regexp.new(:any)
  end

  def oneof(*args)
    Regexp.new(:oneof, args)
  end

  def except(*args)
    Regexp.new(:except, args)
  end

  def first
    Regexp.new(:first)
  end

  def last
    Regexp.new(:last)
  end

  def lit(x)
    Regexp.new(:lit, x)
  end

end

def ARE(*args)
  ARE.concat(args.map {|a| ARE.lit(a) })
end
#
#re = ARE(1,2) + (ARE.empty | ARE(1)) + ARE.oneof(1,2,3) + ARE.except(2,3,4)
#
#re =~ [1,2,3,1]
#
#p ARE(1) =~ [1]
#p ARE(1,2) =~ [1,2]
#p ARE.oneof(1,2,3) =~ [3]
#p ARE(1) + (ARE(2) | ARE(3)) + ARE(4) =~ [1,3,4]
#
#transition = ARE::Transition.new(:a, :state2, :state3)
#
#p transition
#
#nfa = ARE::FSA.new
#
#nfa.states.add(:state1)
#nfa.states.add(:state2)
#nfa.states.add(:state3)
#
#nfa.start = :state1
#
#nfa.acceptings.add(:state3)
#
#nfa.transitions.add(ARE::Transition.new(1, :state1, :state2))
#nfa.transitions.add(ARE::Transition.new(2, :state2, :state2))
#nfa.transitions.add(ARE::Transition.new(nil, :state2, :state3))
#
#p nfa.type
#
#p nfa
#
#f = ARE::StateFactory.new
#p f.next
#p f.next
#
