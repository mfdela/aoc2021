defmodule Aoc2021.Day11.Test do
  use ExUnit.Case
  doctest Aoc2021.Day11

  test "day11" do
    input_test = """
    5483143223
    2745854711
    5264556173
    6141336146
    6357385478
    4167524645
    2176841721
    6882881134
    4846848554
    5283751526
    """

    assert Aoc2021.Day11.run(:part1, input_test) == 1656
    assert Aoc2021.Day11.run(:part1) == 1562
    # assert Aoc2021.Day11.run(:part2, input_test) == 288_957
    # assert Aoc2021.Day11.run(:part2) == 1_190_420_163
  end
end
