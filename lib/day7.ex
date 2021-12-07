defmodule Aoc2021.Day7 do
  def run(part) do
    # If not passed any argument then
    # load the input file
    File.read!("inputs/day7_input.txt")
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
    |> String.trim("\n")
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  defp main(input, part) do
    case part do
      :part1 ->
        median = trunc(Statistics.median(input))
        # the function that minimize geometric distances is the median
        Enum.reduce(input, 0, fn n, acc -> acc + abs(n - median) end)

      :part2 ->
        mean = trunc(Statistics.mean(input) + 1 / 2)
        # the function that minimize quadratic distance is the median
        # when distance between a and b is (a-b)*(a-b+1)/2
        # since mean is not integer, evaluate at [mean-1, mean, mean+1]
        Enum.min(
          Enum.reduce(-1..1, [], fn i, min ->
            min ++
              [
                Enum.reduce(input, 0, fn n, acc ->
                  acc + div(abs(n - (mean + i)) * (abs(n - (mean + i)) + 1), 2)
                end)
              ]
          end)
        )
    end
  end
end
