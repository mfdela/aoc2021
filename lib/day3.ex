defmodule Aoc2021.Day3 do
  def run(part) do
    # If not passed any argument then
    # load the input file
    File.read!("inputs/day3_input.txt")
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
    # Translates strings to integers
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn l -> l |> String.split("", trim: true) |> Enum.map(&String.to_integer/1) end)
  end

  defp main(input, part) do
    [first | _] = input
    size = length(first)
    acc = List.duplicate(0, size)
    # each element l is a list of {0, 1}
    gamma =
      input
      |> Enum.reduce(acc, fn l, acc -> Enum.with_index(l) |> Enum.reduce(acc, &count_0_1/2) end)
      |> Enum.map(fn n ->
        cond do
          n > 0 -> 1
          n < 0 -> 0
        end
      end)

    epsilon =
      gamma
      |> Enum.map(fn n ->
        case n do
          0 -> 1
          1 -> 0
        end
      end)

    {gamma_d, _} = Integer.parse(Enum.join(gamma, ""), 2)
    {epsilon_d, _} = Integer.parse(Enum.join(epsilon, ""), 2)

    case part do
      :part1 -> gamma_d * epsilon_d
    end
  end

  defp count_0_1({n, i}, acc) do
    case n do
      0 -> List.update_at(acc, i, &(&1 - 1))
      1 -> List.update_at(acc, i, &(&1 + 1))
    end
  end
end
