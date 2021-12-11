defmodule Aoc2021.Day9 do
  def run(part) do
    # If not passed any argument then
    # load the input file
    File.read!("inputs/day9_input.txt")
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
    m =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, "", trim: true))
      |> Enum.map(fn row ->
        Enum.map(row, fn i ->
          String.to_integer(i)
        end)
      end)
      |> Enum.map(fn row ->
        [9999] ++ row ++ [9999]
      end)

    # Introduce artificial boundaries to avoid ugly checks for boundaries condition
    # since 9 it's the maximum number, we can use an higher number as boundary

    columns = length(Enum.at(m, 0))
    boundary = List.duplicate(9999, columns)
    [boundary] ++ m ++ [boundary]
  end

  defp main(input, part) do
    rows = length(input)
    columns = length(Enum.at(input, 0))
    checks = [[-1, 0], [1, 0], [0, 1], [0, -1]]

    {_, min_map} =
      Enum.reduce(1..(rows - 2), {input, %{}}, fn r, {input, min} ->
        m_map =
          Enum.reduce(1..(columns - 2), min, fn c, m ->
            i = Enum.at(Enum.at(input, r), c)
            neigh = Enum.map(checks, fn [x, y] -> Enum.at(Enum.at(input, r + x), c + y) end)

            if i < 9 and i < Enum.min(neigh) do
              Map.put(m, [r, c], i)
            else
              m
            end
          end)

        {input, m_map}
      end)

    case part do
      :part1 ->
        # sum each (number + 1) is equal to
        # sum(number) + n
        Enum.reduce(min_map, 0, fn {_, min}, acc -> acc + min + 1 end)

      :part2 ->
        Enum.reduce(Map.keys(min_map), [], fn [r, c], basin_sizes ->
          basin_sizes ++ [length(basins(input, rows, columns, r, c))]
        end)
        |> Enum.sort(&(&1 >= &2))
        |> Enum.slice(0..2)
        |> Enum.reduce(1, fn i, x -> i * x end)
    end
  end

  defp basins(input, rows, columns, r, c) do
    {_, basin_list} = basin(input, rows, columns, r, c, %{}, [[r, c]])
    basin_list
  end

  defp basin(input, rows, columns, r, c, visited, basin_list) do
    cond do
      Map.has_key?(visited, [r, c]) or r == 0 or r == rows or c == 0 or c == columns or
          Enum.at(Enum.at(input, r), c) == 9 ->
        {visited, basin_list}

      true ->
        visited_new = Map.put(visited, [r, c], true)
        checks = [[-1, 0], [1, 0], [0, 1], [0, -1]]

        Enum.reduce(checks, {visited_new, basin_list}, fn [x, y], {vl, bl} ->
          value = Enum.at(Enum.at(input, r), c)
          neigh = Enum.at(Enum.at(input, r + x), c + y)

          if neigh < 9 and not Map.has_key?(vl, [r + x, c + y]) and value < neigh do
            basin(input, rows, columns, r + x, c + y, vl, bl ++ [[r + x, c + y]])
          else
            {vl, bl}
          end
        end)
    end
  end
end
