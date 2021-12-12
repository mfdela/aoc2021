defmodule Aoc2021.Day10.Test do
  use ExUnit.Case
  doctest Aoc2021.Day10

  test "day10" do
    input_test = """
    [({(<(())[]>[[{[]{<()<>>
    [(()[<>])]({[<{<<[]>>(
    {([(<{}[<>[]}>{[]{[(<()>
    (((({<>}<{<{<>}{[]{[]{}
    [[<[([]))<([[{}[[()]]]
    [{[{({}]{}}([{[{{{}}([]
    {<[[]]>}<{[{[{[]{()[[[]
    [<(<(<(<{}))><([]([]()
    <{([([[(<>()){}]>(<<{{
    <{([{{}}[<[[[<>{}]]]>[]]
    """

    assert Aoc2021.Day10.run(:part1, input_test) == 26397
    assert Aoc2021.Day10.run(:part1) == 26397
    # assert Aoc2021.Day10.run(:part2, input_test) == 1134
    # assert Aoc2021.Day10.run(:part2) == 900_900
  end
end
