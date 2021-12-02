defmodule Aoc2021.Day2 do
  def run(part) do
    # If not passed any argument then
    # load the input file
    File.read!("inputs/day2_input.txt")
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
    |> Enum.map(fn x -> Regex.run(~r/(\w+)\s+(\d+)/, x, capture: :all_but_first) end)
    |> Enum.map(fn [dir, value] -> [dir, String.to_integer(value)] end)
  end

  defp main(input, part) do
    {hor, orig_dep, _aim, dep} = Enum.reduce(input, {0, 0, 0, 0}, &acc_position/2)

    case part do
      :part1 -> hor * orig_dep
      :part2 -> hor * dep
    end
  end

  defp acc_position([dir, value], {hor, orig_dep, aim, dep}) do
    case dir do
      "forward" -> {hor + value, orig_dep, aim, dep + aim * value}
      "up" -> {hor, orig_dep - value, aim - value, dep}
      "down" -> {hor, orig_dep + value, aim + value, dep}
      _ -> {hor, orig_dep, aim, dep}
    end
  end
end
