defmodule Aoc2021.Day6 do
  def run(part) do
    # If not passed any argument then
    # load the input file
    File.read!("inputs/day6_input.txt")
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
    state =
      Enum.reduce(0..8, %{}, fn i, s ->
        Map.update(s, i, 0, fn _ -> 0 end)
      end)

    input
    |> String.trim("\n")
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.reduce(state, fn f, state ->
      Map.update(state, f, 1, fn count -> count + 1 end)
    end)
  end

  defp main(input_state, part) do
    days =
      case part do
        :part1 -> 80
        :part2 -> 256
      end

    # a map where each number from 0 to 8 shows the number of fishes in that state

    final_list =
      Enum.reduce(1..days, input_state, fn _day, state ->
        new_state =
          Enum.reduce(8..1//-1, state, fn d, ns ->
            Map.update(ns, d - 1, 0, fn _ ->
              state[d]
            end)
          end)

        Map.update(new_state, 8, 0, fn _ -> state[0] end)
        |> Map.update(6, 0, fn _ -> state[0] + new_state[6] end)
      end)

    Enum.reduce(final_list, 0, fn {_, count}, acc -> acc + count end)
  end
end
