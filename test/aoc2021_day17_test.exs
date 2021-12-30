defmodule Aoc2021.Day17.Test do
  use ExUnit.Case
  doctest Aoc2021.Day17

  test "day17" do
    input_test = """
    target area: x=20..30, y=-10..-5
    """

    assert Aoc2021.Day17.run(:part1, input_test) == 45
    assert Aoc2021.Day17.run(:part1) == 15931
    assert Aoc2021.Day17.run(:part2, input_test) == 112
    assert Aoc2021.Day17.run(:part2) == 2555
  end
end
