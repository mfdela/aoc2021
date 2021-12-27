defmodule Aoc2021.Day15.Test do
  use ExUnit.Case
  @moduletag timeout: :infinity
  doctest Aoc2021.Day15

  test "day15" do
    input_test = """
    1163751742
    1381373672
    2136511328
    3694931569
    7463417111
    1319128137
    1359912421
    3125421639
    1293138521
    2311944581
    """

    assert Aoc2021.Day15.run(:part1, input_test) == 40
    assert Aoc2021.Day15.run(:part1) == 508
    assert Aoc2021.Day15.run(:part2, input_test) == 315
    assert Aoc2021.Day15.run(:part2) == 2872
  end
end
