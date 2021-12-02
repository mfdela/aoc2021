defmodule Aoc2021.Day1 do
  def run(part) do
    # If not passed any argument then
    # load the input file
    {_, result} =
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
    {_, result} =
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
    |> Enum.with_index()
  end

  defp compute_increased(list_of_measures, window) do
    # iterates over the list of measures as inputs
    # and compare each value with the previous one,
    # incrementing the accumulator if the value is larger.
    # In order to compare with the previous value we need to create
    # a list with values and their relative index, and pass
    # the whole list to the reduce function, to access the
    # position i-1. The accumulator parameters passed to Enum.reduce/3 is
    # thus the tuple {whole list, window, acc}, with acc counting the number of times the
    # measure increases
    # window is the parametes that define the sliding window. For part1 of the problem it's simply
    # equal to 1 (compare value with its predecessor). For part2 it's equal to 3

    list_of_aggregated_measures =
      cond do
        window == 1 ->
          list_of_measures

        window > 1 ->
          list_of_measures
          |> Enum.reduce({list_of_measures, window, {}}, &aggregate_window/2)
          |> elem(2)
          |> Tuple.to_list()
          |> Enum.with_index()
      end

    Enum.reduce(
      list_of_aggregated_measures,
      {list_of_aggregated_measures, 0},
      &compare_previous/2
    )
  end

  defp aggregate_window({value, index}, {list_of_measures, window, aggregated_list}) do
    # creates a new list aggregating by sliding window

    sum =
      Enum.reduce_while(1..(window - 1), value, fn i, acc ->
        if index + i < length(list_of_measures) - 1 do
          {:cont, acc + elem(Enum.at(list_of_measures, index + i), 0)}
        else
          {:halt, acc}
        end
      end)

    {list_of_measures, window, Tuple.append(aggregated_list, sum)}
  end

  defp compare_previous({_, 0}, acc) do
    # First elelement of the list, there's no previous element
    # to compare.
    acc
  end

  defp compare_previous({value, index}, {list_of_measures, count}) do
    # list_of_measures is a list of tuples {value, index}
    count =
      cond do
        value > elem(Enum.at(list_of_measures, index - 1), 0) -> count + 1
        true -> count
      end

    {list_of_measures, count}
  end
end
