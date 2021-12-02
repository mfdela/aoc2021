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
    case part do
      :part1 ->
        input
        |> compute_position()
    end
  end

  defp compute_position(input) do
    {hor, dep} = Enum.reduce(input, {0, 0}, &acc_position/2)
    hor * dep
  end

  defp acc_position([dir, value], {hor, dep}) do
    case dir do
      "forward" -> {hor + value, dep}
      "up" -> {hor, dep - value}
      "down" -> {hor, dep + value}
      _ -> {hor, dep}
    end
  end
end
