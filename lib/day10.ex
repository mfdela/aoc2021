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
    stack = []
    map = %{"{" => "}", "(" => ")", "[" => "]", "<" => ">"}
    scores = %{")" => 3, "]" => 57, "}" => 1197, ">" => 25137}

    s =
      Enum.map(input, fn line ->
        {_stack, first_err} =
          Enum.reduce_while(String.split(line, "", trim: true), {[], []}, fn c, {s, fe} ->
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

        first_err
      end)

    case part do
      :part1 ->
        Enum.reduce(s, 0, fn x, score ->
          if(not Enum.empty?(x)) do
            score + scores[Enum.at(x, 0)]
          else
            score
          end
        end)
    end
  end
end
