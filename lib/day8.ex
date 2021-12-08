defmodule Aoc2021.Day8 do
  def run(part) do
    # If not passed any argument then
    # load the input file
    File.read!("inputs/day8_input.txt")
    |> parse_input()
    |> main(part)
  end

  def run(part, test_input) do
    # If passed the input as an argument then use it
    test_input
    |> parse_input()
    |> main(part)
  end

  defp parse_input(input) do
    # a map where each number from 0 to 8 shows the number of fishes in that state
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, "|", trim: true))
    |> Enum.map(fn line ->
      [i, o] = line
      [String.trim(i, " "), String.trim(o, " ")]
    end)
  end

  defp main(input, part) do
    IO.inspect(input)

    output_digits =
      Enum.map(input, fn line ->
        [_i, o] = line
        o
      end)

    unique_output_digits = count_unique(output_digits)

    case part do
      :part1 -> unique_output_digits
    end
  end

  defp count_unique(list) do
    list
    |> Enum.map(fn line -> String.split(line, " ", trim: true) end)
    |> Enum.reduce(0, fn lw, count ->
      IO.inspect(lw)

      count +
        length(
          Enum.filter(lw, fn word ->
            size = String.length(word)
            size == 2 or size == 3 or size == 4 or size == 7
          end)
        )
    end)
  end
end
