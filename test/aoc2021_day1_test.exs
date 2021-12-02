defmodule Aoc2021.Day1.Test do
  use ExUnit.Case
  doctest Aoc2021.Day1

  test "day1" do
    input_test = """
    199
    200
    208
    210
    200
    207
    240
    269
    260
    263
    """

    assert Aoc2021.Day1.run(:part1, input_test) == 7
    assert Aoc2021.Day1.run(:part2, input_test) == 5
  end
end
