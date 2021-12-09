defmodule Aoc2021.Day8 do
  def run(part) do
    # If not passed any argument then
    # load the input file
    File.read!("inputs/day8_input.txt")
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
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, "|", trim: true))
    |> Enum.map(fn line ->
      [i, o] = line
      [String.split(i, " ", trim: true), String.split(o, " ", trim: true)]
    end)
  end

  defp main(input, part) do
    # list of segments are seta, to use nice set functions
    # each digits maps to the set of segments identified by
    # a letter from a to g
    # digits = %{
    #  0 => MapSet.new(String.split("abcefg", "", trim: true)),
    #  1 => MapSet.new(String.split("cf", "", trim: true)),
    #  2 => MapSet.new(String.split("acdeg", "", trim: true)),
    #  3 => MapSet.new(String.split("acdfg", "", trim: true)),
    #  4 => MapSet.new(String.split("bcdf", "", trim: true)),
    #  5 => MapSet.new(String.split("abdfg", "", trim: true)),
    #  6 => MapSet.new(String.split("abdefg", "", trim: true)),
    #  7 => MapSet.new(String.split("acf", "", trim: true)),
    #  8 => MapSet.new(String.split("abcdefg", "", trim: true)),
    #  9 => MapSet.new(String.split("abcdfg", "", trim: true))
    # }

    output =
      Enum.reduce(input, [], fn line, out ->
        {wiring, output_digits} = scan_digits(line)

        # wiring contains the set of segments for each digit
        # MapSet.difference(digits[2], digits[5]) is 2 segments,
        # same for 5 and 2 (but not the same 2 segments as above)
        # difference between 2 and 3 is 1
        # difference between 3 and 5 is 1

        # = wiring[3] and wiring[5]
        sets_2_3_5 = wiring[2]

        # if diff == 2, the two digits are 2 and 5, the remaining set is the digit 3
        set3 =
          cond do
            MapSet.size(MapSet.difference(Enum.at(sets_2_3_5, 0), Enum.at(sets_2_3_5, 1))) == 2 ->
              Enum.at(sets_2_3_5, 2)

            MapSet.size(MapSet.difference(Enum.at(sets_2_3_5, 0), Enum.at(sets_2_3_5, 2))) == 2 ->
              Enum.at(sets_2_3_5, 1)

            MapSet.size(MapSet.difference(Enum.at(sets_2_3_5, 1), Enum.at(sets_2_3_5, 2))) == 2 ->
              Enum.at(sets_2_3_5, 0)

            true ->
              IO.puts("Error")
          end

        # assign the set for digit 3 and remove the set from digits 2 and 5
        w0 =
          Map.update(wiring, 3, set3, fn _ -> set3 end)
          |> Map.update(2, [], fn v -> List.delete(v, set3) end)
          |> Map.update(5, [], fn v -> List.delete(v, set3) end)

        # MapSet.difference(digits[5], digits[4]) = 2
        # MapSet.difference(digits[2], digits[4]) = 3
        sets_2_5 = w0[2]

        set5 =
          Enum.reduce(0..1, sets_2_5, fn i, acc ->
            if MapSet.size(MapSet.difference(Enum.at(sets_2_5, i), w0[4])) == 2 do
              Enum.at(sets_2_5, i)
            else
              acc
            end
          end)

        # assign the set for digit 5 and remove the set from digits 2
        w1 =
          Map.update(w0, 5, set5, fn _ -> set5 end)
          |> Map.update(2, [], fn v -> Enum.at(List.delete(v, set5), 0) end)

        # MapSet.difference(digits[0], digits[1]) = 4
        # MapSet.difference(digits[6], digits[1]) = 5
        # MapSet.difference(digits[9], digits[1]) = 4

        sets_0_6_9 = w1[0]

        set6 =
          Enum.reduce(0..2, sets_0_6_9, fn i, acc ->
            if MapSet.size(MapSet.difference(Enum.at(sets_0_6_9, i), w1[1])) == 5 do
              Enum.at(sets_0_6_9, i)
            else
              acc
            end
          end)

        # assign the set for digit 6 and remove the set from digits 0 and 9
        w2 =
          Map.update(w1, 6, set6, fn _ -> set6 end)
          |> Map.update(0, [], fn v -> List.delete(v, set6) end)
          |> Map.update(9, [], fn v -> List.delete(v, set6) end)

        # MapSet.difference(digits[0], digits[4]) = 3
        # MapSet.difference(digits[9], digits[4]) = 2
        sets_0_9 = w2[0]

        set0 =
          Enum.reduce(0..1, sets_0_9, fn i, acc ->
            if MapSet.size(MapSet.difference(Enum.at(sets_0_9, i), w2[4])) == 3 do
              Enum.at(sets_0_9, i)
            else
              acc
            end
          end)

        # assign the set for digit 0 and remove the set from digit 9
        w3 =
          Map.update(w2, 0, set0, fn _ -> set0 end)
          |> Map.update(9, [], fn v -> Enum.at(List.delete(v, set0), 0) end)

        # search for output digits in wiring set
        # invert the wiring map to expedite search
        wiring_digits = Map.new(w3, fn {key, val} -> {val, key} end)

        out ++
          [
            Enum.reduce(output_digits, [], fn d, acc ->
              acc ++ [wiring_digits[d]]
            end)
          ]
      end)

    case part do
      :part1 ->
        count_unique_easy(output)

      :part2 ->
        Enum.reduce(output, 0, fn l, acc ->
          acc + String.to_integer(Enum.join(l))
        end)
    end
  end

  defp count_unique_easy(list) do
    list
    |> Enum.reduce(0, fn ld, count_1_4_7_8 ->
      count_1_4_7_8 +
        length(
          Enum.filter(ld, fn digit ->
            digit == 1 or digit == 4 or digit == 7 or digit == 8
          end)
        )
    end)
  end

  defp scan_digits(line) do
    [i, o] = line

    w =
      Enum.reduce(
        i,
        %{
          0 => [],
          1 => [],
          2 => [],
          3 => [],
          4 => [],
          5 => [],
          6 => [],
          7 => [],
          8 => [],
          9 => []
        },
        fn word, m ->
          set = MapSet.new(String.split(word, "", trim: true))

          case String.length(word) do
            2 ->
              # this is digit 1
              Map.update(m, 1, set, fn _ -> set end)

            3 ->
              # this is digit 7
              Map.update(m, 7, set, fn _ -> set end)

            4 ->
              # This is digit 4
              Map.update(m, 4, set, fn _ -> set end)

            7 ->
              # this is digit 8
              Map.update(m, 8, set, fn _ -> set end)

            5 ->
              # this is digit 2 or 3 or 5
              Map.update(m, 2, [set], fn v -> v ++ [set] end)
              |> Map.update(3, [set], fn v -> v ++ [set] end)
              |> Map.update(5, [set], fn v -> v ++ [set] end)

            6 ->
              # this is digit 0, 6 or 9
              Map.update(m, 0, [set], fn v -> v ++ [set] end)
              |> Map.update(6, [set], fn v -> v ++ [set] end)
              |> Map.update(9, [set], fn v -> v ++ [set] end)
          end
        end
      )

    out =
      Enum.reduce(o, [], fn d, list ->
        list ++ [MapSet.new(String.split(d, "", trim: true))]
      end)

    {w, out}
  end
end
