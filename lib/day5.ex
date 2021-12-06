defmodule Aoc2021.Day5 do
  def run(part) do
    # If not passed any argument then
    # load the input file
    File.read!("inputs/day5_input.txt")
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
    |> Enum.map(fn x -> Regex.run(~r/([\w,]+)\s+->\s+([\w,]+)/, x, capture: :all_but_first) end)
    |> Enum.map(fn point ->
      Enum.reduce(point, [], fn coord, points ->
        points ++
          (String.split(coord, ",", trim: true)
           |> Enum.map(&String.to_integer/1))
      end)
    end)
  end

  defp main(input, part) do
    diagonals =
      case part do
        :part1 -> false
        :part2 -> true
      end

    crossing_points =
      Enum.reduce(input, %{}, fn line, cross_points ->
        line_points(line, diagonals, cross_points)
      end)

    Enum.reduce(crossing_points, 0, fn {{_, _}, count}, acc ->
      if count > 1 do
        acc + 1
      else
        acc
      end
    end)
  end

  defp line_points(line, diagonals, cross_points) do
    [xa, ya, xb, yb] = line
    [xi, xf] = [min(xa, xb), max(xa, xb)]
    [yi, yf] = [min(ya, yb), max(ya, yb)]

    cond do
      xa == xb ->
        Enum.reduce(
          Range.new(yi, yf, 1),
          cross_points,
          fn y, p ->
            Map.update(p, {xa, y}, 1, fn count ->
              count + 1
            end)
          end
        )

      ya == yb ->
        [xi, xf] = [min(xa, xb), max(xa, xb)]

        Enum.reduce(
          Range.new(xi, xf, 1),
          cross_points,
          fn x, p ->
            Map.update(p, {x, ya}, 1, fn count ->
              count + 1
            end)
          end
        )

      diagonals and xf - xi == yf - yi ->
        # 45 degrees
        dir_x = div(xb - xa, abs(xb - xa))
        dir_y = div(yb - ya, abs(yb - ya))

        Enum.reduce(
          Range.new(0, xf - xi, 1),
          cross_points,
          fn i, p ->
            Map.update(p, {xa + i * dir_x, ya + i * dir_y}, 1, fn count ->
              count + 1
            end)
          end
        )

      true ->
        cross_points
    end
  end
end
