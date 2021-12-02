defmodule Aoc2021.Day2.Test do
  use ExUnit.Case
  doctest Aoc2021.Day2

  test "day2" do
    input_test = """
    forward 5
    down 5
    forward 8
    up 3
    down 8
    forward 2
    """

    assert Aoc2021.Day2.run(:part1, input_test) == 150
    # assert Aoc2021.Day2.run(:part2, input_test) == 150
  end
end
