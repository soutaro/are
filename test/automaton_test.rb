require "test_helper"

class AutomatonTest < MiniTest::Unit::TestCase
  def test_nfa_without_epsilon
    nfa = ARE::FSA.new()

    nfa.states << :s1
    nfa.states << :s2

    nfa.start = :s1
    nfa.acceptings << :s2

    nfa.transitions << ARE::Transition.new(1, :s1, :s2)
    nfa.transitions << ARE::Transition.new(1, :s1, :s1)

    refute nfa.deterministic?
    refute nfa.with_epsilon?
  end

  def test_nfa_with_epsilon
    nfa = ARE::FSA.new()

    nfa.states << :s1
    nfa.states << :s2

    nfa.start = :s1
    nfa.acceptings << :s2

    nfa.transitions << ARE::Transition.new(1, :s1, :s2)
    nfa.transitions << ARE::Transition.new(nil, :s1, :s1)

    assert nfa.deterministic?
    assert nfa.with_epsilon?
  end

  def test_dfa
    dfa = ARE::FSA.new()

    dfa.states << :s1
    dfa.states << :s2

    dfa.start = :s1
    dfa.acceptings << :s2

    dfa.transitions << ARE::Transition.new(1, :s1, :s2)
    dfa.transitions << ARE::Transition.new(2, :s1, :s1)

    assert dfa.deterministic?
    refute dfa.with_epsilon?
  end

  def test_drives
    nfa = ARE::FSA.new()

    nfa.states << :s1
    nfa.states << :s2

    nfa.start = :s1
    nfa.acceptings << :s2

    nfa.transitions << ARE::Transition.new(1, :s1, :s2)
    nfa.transitions << ARE::Transition.new(1, :s1, :s1)

    assert_equal Set.new([:s1, :s2]), nfa.drives(:s1, 1)
    assert_equal Set.new, nfa.drives(:s2, 3)
  end

  def test_subset_construction
    nfa = ARE::FSA.new()

    nfa.states << :q0
    nfa.states << :q1
    nfa.states << :q2

    nfa.start = :q0
    nfa.acceptings << :q2

    nfa.transitions << ARE::Transition.new(0, :q0, :q0)
    nfa.transitions << ARE::Transition.new(1, :q0, :q0)
    nfa.transitions << ARE::Transition.new(0, :q0, :q1)
    nfa.transitions << ARE::Transition.new(1, :q1, :q2)

    refute nfa.deterministic?
    refute nfa.with_epsilon?


    dfa = ARE::FSA.dfa_from_nfa(nfa)


    assert dfa.deterministic?
    refute nfa.with_epsilon?
  end
end