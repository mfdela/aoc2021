defmodule Aoc2021.Day14.Test do
  use ExUnit.Case
  doctest Aoc2021.Day14

  test "day14" do
    input_test = """
    NNCB

    CH -> B
    HH -> N
    CB -> H
    NH -> C
    HB -> C
    HC -> B
    HN -> C
    NN -> C
    BH -> H
    NC -> B
    NB -> B
    BN -> B
    BB -> N
    BC -> B
    CC -> N
    CN -> C
    """

    assert Aoc2021.Day14.run(:part1, input_test) == 1588
    assert Aoc2021.Day14.run(:part1) == 3213
    assert Aoc2021.Day14.run(:part2, input_test) == 2_188_189_693_529
    assert Aoc2021.Day14.run(:part2) == 3_711_743_744_429
  end
end
