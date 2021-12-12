defmodule Aoc2021.Day10 do
  def run(part) do
    # If not passed any argument then
    # load the input file
    File.read!("inputs/day10_input.txt")
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
  end

  defp main(input, part) do
    # check chunks with a stack structure
    map = %{"{" => "}", "(" => ")", "[" => "]", "<" => ">"}
    scores = %{")" => 3, "]" => 57, "}" => 1197, ">" => 25137}
    scores2 = %{")" => 1, "]" => 2, "}" => 3, ">" => 4}

    sol =
      Enum.map(input, fn line ->
        Enum.reduce_while(String.split(line, "", trim: true), {[], []}, fn c, {s, _fe} ->
          cond do
            c == "{" or c == "(" or c == "[" or c == "<" ->
              {:cont, {[c | s], []}}

            c == "}" or c == ")" or c == "]" or c == ">" ->
              [h | t] = s
              closed = map[h]

              if c == closed do
                {:cont, {t, []}}
              else
                {:halt, {s, [c]}}
              end

            true ->
              {s, []}
          end
        end)
      end)

    case part do
      :part1 ->
        Enum.reduce(sol, 0, fn {_, x}, score ->
          if(not Enum.empty?(x)) do
            score + scores[Enum.at(x, 0)]
          else
            score
          end
        end)

      :part2 ->
        res =
          Enum.reduce(sol, [], fn {s, err}, inc ->
            if Enum.empty?(err) and not Enum.empty?(s) do
              inc ++ [s]
            else
              inc
            end
          end)
          |> Enum.map(fn line ->
            Enum.map(line, fn c -> map[c] end)
          end)
          |> Enum.map(fn line ->
            Enum.reduce(line, 0, fn c, s ->
              s * 5 + scores2[c]
            end)
          end)
          |> Enum.sort()

        Enum.slice(res, div(length(res) - 1, 2), 1)
        |> Enum.at(0)
    end
  end
end
