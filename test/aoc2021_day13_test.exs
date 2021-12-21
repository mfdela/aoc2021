defmodule Aoc2021.Day13.Test do
  use ExUnit.Case
  doctest Aoc2021.Day13

  test "day13" do
    input_test = """
    6,10
    0,14
    9,10
    0,3
    10,4
    4,11
    6,0
    6,12
    4,1
    0,13
    10,12
    3,4
    3,0
    8,4
    1,10
    2,14
    8,10
    9,0

    fold along y=7
    fold along x=5
    """

    assert Aoc2021.Day13.run(:part1, input_test) == 17
    assert Aoc2021.Day13.run(:part1) == 735
    assert Aoc2021.Day13.run(:part2, input_test) == :ok
    assert Aoc2021.Day13.run(:part2) == :ok
  end
end
