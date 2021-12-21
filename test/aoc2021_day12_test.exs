defmodule Aoc2021.Day12.Test do
  use ExUnit.Case
  doctest Aoc2021.Day12

  test "day12" do
    input_test1 = """
    start-A
    start-b
    A-c
    A-b
    b-d
    A-end
    b-end
    """

    input_test2 = """
    fs-end
    he-DX
    fs-he
    start-DX
    pj-DX
    end-zg
    zg-sl
    zg-pj
    pj-he
    RW-he
    fs-DX
    pj-RW
    zg-RW
    start-pj
    he-WI
    zg-he
    pj-fs
    start-RW
    """

    assert Aoc2021.Day12.run(:part1, input_test1) == 10
    assert Aoc2021.Day12.run(:part1, input_test2) == 226
    assert Aoc2021.Day12.run(:part1) == 3000
    assert Aoc2021.Day12.run(:part2, input_test1) == 36
    assert Aoc2021.Day12.run(:part2, input_test2) == 3509
    assert Aoc2021.Day12.run(:part2) == 74222
  end
end
