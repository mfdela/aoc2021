defmodule Aoc2021.Day11 do
  def run(part) do
    # If not passed any argument then
    # load the input file
    File.read!("inputs/day11_input.txt")
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
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, "", trim: true))
    |> Enum.map(fn row ->
      Enum.map(row, fn i -> String.to_integer(i) end)
    end)
  end

  defp main(input, part) do
    {_out, total_flashes} =
      Enum.reduce(1..100, {input, 0}, fn _step, {matrix, num_flashes} ->
        increase_1(matrix)
        |> flashes(num_flashes)
      end)

    case part do
      :part1 -> total_flashes
      :part2 -> total_flashes
    end
  end

  defp increase_1(matrix) do
    Enum.map(matrix, fn row -> Enum.map(row, fn i -> i + 1 end) end)
  end

  defp flashes(input, total_flashes) do
    {flash_m, flash_n} = check_flashes(input)
    flashes(flash_m, flash_n, total_flashes + flash_n)
  end

  def flashes(input, 0, total_flashes) do
    {input, total_flashes}
  end

  def flashes(input, _num_flashes, total_flashes) do
    {fm, nf} = check_flashes(input)
    flashes(fm, nf, total_flashes + nf)
  end

  defp check_flashes(input) do
    size = length(input)

    {flash_m, num_flashes} =
      for r <- 0..(size - 1),
          c <- 0..(size - 1),
          reduce: {input, 0} do
        acc ->
          {matrix, nf} = acc
          i = Enum.at(Enum.at(matrix, r), c)

          if i > 9 do
            row = List.update_at(Enum.at(matrix, r), c, fn _ -> 0 end)
            m = List.update_at(matrix, r, fn _ -> row end)
            {increase_adj(m, r, c), nf + 1}
          else
            acc
          end
      end

    {flash_m, num_flashes}
  end

  defp increase_adj(m, r, c) do
    size = length(m)

    r_init =
      cond do
        r == 0 -> 0
        true -> -1
      end

    r_fin =
      cond do
        r == size - 1 -> 0
        true -> 1
      end

    c_init =
      cond do
        c == 0 -> 0
        true -> -1
      end

    c_fin =
      cond do
        c == size - 1 -> 0
        true -> 1
      end

    for x <- r_init..r_fin, y <- c_init..c_fin, reduce: m do
      acc ->
        i = Enum.at(Enum.at(acc, r + x), c + y)

        if i > 0 and (x != 0 or y != 0) do
          new_value = i + 1
          row = List.update_at(Enum.at(acc, r + x), c + y, fn _ -> new_value end)
          List.update_at(acc, r + x, fn _ -> row end)
        else
          acc
        end
    end
  end
end
