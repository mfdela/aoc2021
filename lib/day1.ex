defmodule Aoc2021.Day1 do
  def run(part) do
    # If not passed any argument then
    # load the input file
    result =
      case part do
        :part1 ->
          File.read!("inputs/day1_input.txt")
          |> clean_input()
          |> compute_increased(1)

        :part2 ->
          File.read!("inputs/day1_input.txt")
          |> clean_input()
          |> compute_increased(3)
      end

    result
  end

  def run(part, test_input) do
    # If passed the input as an argument then use it
    result =
      case part do
        :part1 ->
          test_input
          |> clean_input()
          |> compute_increased(1)

        :part2 ->
          test_input
          |> clean_input()
          |> compute_increased(3)
      end

    result
  end

  defp clean_input(input) do
    # Translates strings to integers
    # and return the list with indexes to be used later
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
