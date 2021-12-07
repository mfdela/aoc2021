defmodule Aoc2021.Day7.Test do
  use ExUnit.Case
  doctest Aoc2021.Day7

  test "day7" do
    input_test = "16,1,2,0,4,2,7,1,2,14"

    assert Aoc2021.Day7.run(:part1, input_test) == 37
    assert Aoc2021.Day7.run(:part1) == 355_989
    assert Aoc2021.Day7.run(:part2, input_test) == 168
    assert Aoc2021.Day7.run(:part2) == 102_245_489
  end
end
