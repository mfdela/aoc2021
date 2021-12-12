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
    assert Aoc2021.Day10.run(:part1) == 389_589
    assert Aoc2021.Day10.run(:part2, input_test) == 288_957
    assert Aoc2021.Day10.run(:part2) == 1_190_420_163
  end
end
