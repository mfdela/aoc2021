defmodule Aoc2021.Day3.Test do
  use ExUnit.Case
  doctest Aoc2021.Day3

  test "day3" do
    input_test = """
    00100
    11110
    10110
    10111
    10101
    01111
    00111
    11100
    10000
    11001
    00010
    01010
    """

    assert Aoc2021.Day3.run(:part1, input_test) == 198
    assert Aoc2021.Day3.run(:part2, input_test) == 230
  end
end
