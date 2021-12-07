defmodule Aoc2021.Day6.Test do
  use ExUnit.Case
  doctest Aoc2021.Day6

  test "day6" do
    input_test = "3,4,3,1,2"

    assert Aoc2021.Day6.run(:part1, input_test) == 5934
    assert Aoc2021.Day6.run(:part1) == 388_419
    assert Aoc2021.Day6.run(:part2, input_test) == 26_984_457_539
    assert Aoc2021.Day6.run(:part2) == 1_740_449_478_328
  end
end
