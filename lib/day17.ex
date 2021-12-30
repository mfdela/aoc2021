defmodule Aoc2021.Day17 do
  def run(part) do
    # If not passed any argument then
    # load the input file
    File.read!("inputs/day17_input.txt")
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
    Regex.run(~r/x=(\d+)\.\.(\d+),\s+y=(-*\d+)\.\.(-*\d+)/, String.trim(input),
      capture: :all_but_first
    )
    |> Enum.map(&String.to_integer/1)
  end

  defp main(input, part) do
    [xi, xf, yi, yf] = input

    {ymax, count} =
      for vx <- 1..xf, vy <- -abs(yi)..abs(yi), reduce: {0, 0} do
        max ->
          {ymax, count} = max
          {found, max, _land} = next_step(vx, vy, {xi, xf}, {yi, yf}, {0, 0}, ymax)

          case found do
            :found ->
              {max, count + 1}

            :not_found ->
              {ymax, count}
          end
      end

    case part do
      :part1 -> ymax
      :part2 -> count
    end
  end

  defp next_step(vx, vy, target_x, target_y, pos, ymax) do
    {pos_x, pos_y} = pos
    {xi, xf} = target_x
    {yi, yf} = target_y

    new_max =
      cond do
        pos_y > ymax -> pos_y
        true -> ymax
      end

    cond do
      pos_x >= xi and pos_x <= xf and pos_y >= yi and pos_y <= yf ->
        {:found, new_max, pos}

      pos_x > xf ->
        {:not_found, 0, pos}

      pos_y < yi ->
        {:not_found, 0, pos}

      true ->
        cond do
          vx == 0 ->
            next_step(0, vy - 1, target_x, target_y, {pos_x, pos_y + vy}, new_max)

          vx > 0 ->
            next_step(vx - 1, vy - 1, target_x, target_y, {pos_x + vx, pos_y + vy}, new_max)

          vx < 0 ->
            next_step(vx + 1, vy - 1, target_x, target_y, {pos_x + vx, pos_y + vy}, new_max)
        end
    end
  end
end
