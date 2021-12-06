defmodule Aoc2021.Day5.Test do
  use ExUnit.Case
  doctest Aoc2021.Day5

  test "day5_part1" do
    input_test = """
    0,9 -> 5,9
    8,0 -> 0,8
    9,4 -> 3,4
    2,2 -> 2,1
    7,0 -> 7,4
    6,4 -> 2,0
    0,9 -> 2,9
    3,4 -> 1,4
    0,0 -> 8,8
    5,5 -> 8,2
    """

    assert Aoc2021.Day5.run(:part1, input_test) == 5
    assert Aoc2021.Day5.run(:part2, input_test) == 12
    assert Aoc2021.Day5.run(:part1) == 7085
    assert Aoc2021.Day5.run(:part2) == 20271
  end
end
