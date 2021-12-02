defmodule Aoc2021.Day1 do
  def run(part) do
    # If not passed any argument then
    # load the input file
    File.read!("inputs/day1_input.txt")
    |> clean_input()
    |> main(part)
  end

  def run(part, test_input) do
    # If passed the input as an argument then use it
    test_input
    |> clean_input()
    |> main(part)
  end

  defp main(input, part) do
    case part do
      :part1 ->
        input
        |> compute_increased(1)

      :part2 ->
        input
        |> compute_increased(3)
    end
  end

  defp clean_input(input) do
    # Translates strings to integers
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  defp compute_increased(list_of_measures, window) do
    # iterates over the list of measures as inputs
    # and compare each value with the previous one,
    # incrementing the accumulator if the value is larger.

    list_of_aggregated_measures =
      cond do
        window == 1 ->
          list_of_measures

        window > 1 ->
          list_of_measures
          |> Enum.chunk_every(window, 1)
          |> Enum.reduce([], fn x, acc -> acc ++ [Enum.sum(x)] end)
      end

    list_of_aggregated_measures
    |> Enum.chunk_every(2, 1, [0])
    |> Enum.reduce(0, &compare_previous/2)
  end

  def compare_previous([a, b], acc) do
    cond do
      b > a -> acc + 1
      true -> acc
    end
  end
end
