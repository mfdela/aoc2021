defmodule Aoc2021.Day14 do
  def run(part) do
    # If not passed any argument then
    # load the input file
    {template, insertions} =
      File.read!("inputs/day14_input.txt")
      |> parse_input()

    main(template, insertions, part)
  end

  def run(part, test_input) do
    # If passed the input as an argument then use it
    {template, insertions} =
      test_input
      |> parse_input()

    main(template, insertions, part)
  end

  defp parse_input(input) do
    strings = String.split(input, "\n", trim: true)
    [template | tail] = strings

    insertions =
      tail
      |> Enum.filter(fn s -> String.match?(s, ~r/->/) end)
      |> Enum.reduce(%{}, fn s, map ->
        [pair, inserted] = String.split(s, ~r"\s*->\s*", trim: true)
        Map.put(map, pair, inserted)
      end)

    {String.split(template, "", trim: true), insertions}
  end

  defp main(template, insertions, part) do
    steps =
      case part do
        :part1 -> 10
        :part2 -> 40
      end

    pairs = Enum.chunk_every(template, 2, 1)

    initial_template =
      Enum.reduce(pairs, %{}, fn p, map ->
        Map.update(map, Enum.join(p, ""), 1, fn val -> val + 1 end)
      end)

    counter =
      Enum.reduce(template, %{}, fn l, map -> Map.update(map, l, 1, fn val -> val + 1 end) end)

    {_out_template, out_counter} =
      Enum.reduce(1..steps, {initial_template, counter}, fn _step, {acc_template, acc_counter} ->
        Enum.reduce(acc_template, {%{}, acc_counter}, fn {pair, count},
                                                         {new_template, new_counter} ->
          if Map.has_key?(insertions, pair) do
            first_new_pair = String.at(pair, 0) <> insertions[pair]
            second_new_pair = insertions[pair] <> String.at(pair, 1)
            nt1 = Map.update(new_template, first_new_pair, count, fn val -> val + count end)
            nt2 = Map.update(nt1, second_new_pair, count, fn val -> val + count end)
            nc = Map.update(new_counter, insertions[pair], count, fn val -> val + count end)
            {nt2, nc}
          else
            {new_template, new_counter}
          end
        end)
      end)

    Enum.max(Map.values(out_counter)) - Enum.min(Map.values(out_counter))
  end
end
