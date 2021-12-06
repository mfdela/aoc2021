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
      |> Enum.map(fn n -> 1 - n end)

    {gamma_d, _} = Integer.parse(Enum.join(gamma, ""), 2)
    {epsilon_d, _} = Integer.parse(Enum.join(epsilon, ""), 2)
    {oxygen, _} = Integer.parse(sieve(input, :most_common, 0, &find_common/3), 2)
    {co2, _} = Integer.parse(sieve(input, :least_common, 0, &find_common/3), 2)

    case part do
      :part1 -> gamma_d * epsilon_d
      :part2 -> oxygen * co2
    end
  end

  defp count_0_1({n, i}, acc) do
    case n do
      0 -> List.update_at(acc, i, &(&1 - 1))
      1 -> List.update_at(acc, i, &(&1 + 1))
    end
  end

  defp sieve(list, bit, bit_position, bit_criteria) do
    nlist = bit_criteria.(bit, bit_position, list)

    case length(nlist) do
      1 -> nlist |> List.flatten() |> Enum.join("")
      _ -> sieve(nlist, bit, bit_position + 1, bit_criteria)
    end
  end

  defp find_common(bit, bit_position, list) do
    # count number of 0 and 1
    {n_0, n_1} =
      list
      |> Enum.reduce({0, 0}, fn l, {n_0, n_1} ->
        case Enum.at(l, bit_position) do
          0 -> {n_0 + 1, n_1}
          1 -> {n_0, n_1 + 1}
        end
      end)

    most_common =
      cond do
        n_0 > n_1 -> 0
        n_0 < n_1 -> 1
        n_0 == n_1 -> 1
      end

    common =
      case bit do
        :most_common -> most_common
        :least_common -> 1 - most_common
      end

    Enum.filter(list, fn l -> Enum.at(l, bit_position) == common end)
  end
end
