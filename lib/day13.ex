defmodule Aoc2021.Day13 do
  def run(part) do
    # If not passed any argument then
    # load the input file
    {dots, instructions} =
      File.read!("inputs/day13_input.txt")
      |> parse_input()

    main(dots, instructions, part)
  end

  def run(part, test_input) do
    # If passed the input as an argument then use it
    {dots, instructions} =
      test_input
      |> parse_input()

    main(dots, instructions, part)
  end

  defp parse_input(input) do
    strings = String.split(input, "\n", trim: true)

    dots =
      strings
      |> Enum.filter(fn s -> not String.match?(s, ~r/^fold/) end)
      |> Enum.map(&String.split(&1, ",", trim: true))
      |> Enum.map(fn [x, y] -> [String.to_integer(x), String.to_integer(y)] end)

    instructions =
      strings
      |> Enum.filter(fn s -> String.match?(s, ~r/^fold/) end)
      |> Enum.map(fn s -> Regex.run(~r/fold along ([x,y])=(\d+)/, s, capture: :all_but_first) end)
      |> Enum.map(fn [a, v] -> [a, String.to_integer(v)] end)

    {dots, instructions}
  end

  defp main(dots, instructions, part) do
    inst_list =
      case part do
        :part1 ->
          [h | _t] = instructions
          [h]

        :part2 ->
          instructions
      end

    out =
      inst_list
      |> Enum.reduce(dots, fn inst, matrix ->
        [axis, amount] = inst

        Enum.map(matrix, fn [x, y] ->
          case axis do
            "y" ->
              if y > amount do
                [x, 2 * amount - y]
              else
                [x, y]
              end

            "x" ->
              if x > amount do
                [2 * amount - x, y]
              else
                [x, y]
              end
          end
        end)
      end)
      |> Enum.uniq()
      |> Enum.sort()

    case part do
      :part1 ->
        length(out)

      :part2 ->
        print_out(out)
    end
  end

  defp print_out(matrix) do
    [rows, columns] =
      Enum.reduce(matrix, [0, 0], fn [x, y], [xmax, ymax] ->
        xm =
          if x > xmax do
            x
          else
            xmax
          end

        ym =
          if y > ymax do
            y
          else
            ymax
          end

        [ym, xm]
      end)

    empty = List.duplicate(List.duplicate(".", columns + 1), rows + 1)

    st =
      Enum.reduce(matrix, empty, fn [x, y], print_m ->
        new_row = List.update_at(Enum.at(print_m, y), x, fn _ -> "#" end)
        List.update_at(print_m, y, fn _r -> new_row end)
      end)

    Enum.each(st, fn row ->
      IO.puts(Enum.join(row, ""))
    end)

    IO.puts("")
  end
end
