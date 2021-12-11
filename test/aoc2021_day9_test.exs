defmodule Aoc2021.Day9.Test do
  use ExUnit.Case
  doctest Aoc2021.Day9

  test "day9" do
    input_test = """
    2199943210
    3987894921
    9856789892
    8767896789
    9899965678
    """

    assert Aoc2021.Day9.run(:part1, input_test) == 15
    assert Aoc2021.Day9.run(:part1) == 439
    assert Aoc2021.Day9.run(:part2, input_test) == 1134
    assert Aoc2021.Day9.run(:part2) == 900_900
  end
end
