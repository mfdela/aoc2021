defmodule Aoc2021.Day16.Test do
  use ExUnit.Case
  doctest Aoc2021.Day16

  test "day16" do
    input_test1 = """
    D2FE28
    """

    input_test2 = """
    8A004A801A8002F478
    """

    input_test3 = """
    620080001611562C8802118E34
    """

    input_test4 = """
    C0015000016115A2E0802F182340
    """

    input_test5 = """
    A0016C880162017C3686B18A3D4780
    """

    input_test6 = """
    9C0141080250320F1802104A08
    """

    assert Aoc2021.Day16.run(:part1, input_test1) == 6
    assert Aoc2021.Day16.run(:part1, input_test2) == 16
    assert Aoc2021.Day16.run(:part1, input_test3) == 12
    assert Aoc2021.Day16.run(:part1, input_test4) == 23
    assert Aoc2021.Day16.run(:part1, input_test5) == 31
    assert Aoc2021.Day16.run(:part1) == 991
    assert Aoc2021.Day16.run(:part2, input_test6) == 1
    assert Aoc2021.Day16.run(:part2) == 1_264_485_568_252
  end
end
