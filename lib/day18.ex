defmodule Aoc2021.Day18 do
  def run(part) do
    # If not passed any argument then
    # load the input file
    File.read!("inputs/day18_input.txt")
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
    String.split(input, "\n", trim: true)
  end

  defp main(input, part) do
    case part do
      :part1 ->
        {mag, _} =
          add_all(input)
          |> stringify
          |> magnitude

        mag

      :part2 ->
        mag_all(input)
    end
  end

  defp stringify(sf) do
    # Macro.to_string(sf)
    sf
    |> String.split(~r{[\[\],]}, include_captures: true, trim: true)
    |> Enum.reject(fn x -> x == " " or x == "\n" end)
  end

  defp add_all(input) do
    [h | t] = input

    for sf <- t, reduce: h do
      acc ->
        add = addition(acc, sf)
        reduce(add)
    end
  end

  defp mag_all(input) do
    pairs = permutations(input, 2)

    for [p1, p2] <- pairs, reduce: 0 do
      acc ->
        cond do
          p1 == p2 ->
            acc

          true ->
            {m, _} =
              addition(p1, p2)
              |> reduce()
              |> stringify
              |> magnitude

            if m > acc do
              m
            else
              acc
            end
        end
    end
  end

  # defp permutations(list), do: permutations(list, length(list))

  defp permutations([], _), do: [[]]
  defp permutations(_, 0), do: [[]]

  defp permutations(list, i) do
    for x <- list, y <- permutations(list, i - 1), do: [x | y]
  end

  defp addition(sf1, sf2) do
    stringify("[" <> sf1 <> "," <> sf2 <> "]")
  end

  defp reduce(sf) do
    out_t =
      reduce_rec(sf)
      |> Enum.map(fn x ->
        case Integer.parse(x) do
          {i, ""} -> i
          _ -> x
        end
      end)
      |> Enum.join("")

    # IO.inspect(out_t, label: "reduced", charlists: :as_lists, pretty: true)

    out_t
  end

  defp reduce_rec(sf) do
    red =
      explode(sf)
      |> split_number()

    cond do
      red === sf -> sf
      true -> reduce_rec(red)
    end
  end

  defp find_nested_four(sf) do
    Enum.with_index(sf)
    |> Enum.reduce_while({false, 0}, fn c, acc ->
      {char, pos} = c
      {_, last_count} = acc

      count =
        case char do
          "[" -> last_count + 1
          "]" -> last_count - 1
          _ -> last_count
        end

      cond do
        count == 5 ->
          {:halt, {true, pos}}

        true ->
          {:cont, {false, count}}
      end
    end)
  end

  defp explode(sf) do
    {is_four_nested, pos} = find_nested_four(sf)
    explode(sf, pos, is_four_nested)
  end

  defp explode(sf, _pos, false) do
    sf
  end

  defp explode(sf, pos, true) do
    left = String.to_integer(Enum.at(sf, pos + 1))
    right = String.to_integer(Enum.at(sf, pos + 3))

    {found_left, left_pos} =
      Enum.reduce_while((pos - 1)..0//-1, sf, fn i, _acc ->
        c = Enum.at(sf, i)

        case Integer.parse(c) do
          {_, ""} -> {:halt, {true, i}}
          _ -> {:cont, {false, i}}
        end
      end)

    {found_right, right_pos} =
      Enum.reduce_while((pos + 4)..(length(sf) - 1), sf, fn i, _acc ->
        c = Enum.at(sf, i)

        case Integer.parse(c) do
          {_, ""} -> {:halt, {true, i}}
          _ -> {:cont, {false, i}}
        end
      end)

    new_sf =
      sf
      |> sum_at(left_pos, left, found_left)
      |> sum_at(right_pos, right, found_right)
      |> zero_at(pos)

    # IO.inspect(Enum.join(sf, ""), label: "before exploded", charlists: :as_lists)
    # IO.inspect(Enum.join(new_sf, ""), label: "after exploded", charlists: :as_lists)
    {is_four_nested, pos} = find_nested_four(new_sf)
    explode(new_sf, pos, is_four_nested)
  end

  defp sum_at(sf, _pos, _val, false) do
    sf
  end

  defp sum_at(sf, pos, val, true) do
    List.update_at(sf, pos, fn v -> to_string(String.to_integer(v) + val) end)
  end

  defp zero_at(sf, pos, val \\ "0") do
    Enum.reduce(4..1//-1, sf, fn i, acc ->
      List.delete_at(acc, pos + i)
    end)
    |> List.update_at(pos, fn _ -> val end)
  end

  defp find_greater_ten(sf) do
    Enum.with_index(sf)
    |> Enum.reduce_while({false, 0}, fn c, _acc ->
      {char, pos} = c

      case Integer.parse(char) do
        {x, ""} ->
          cond do
            x >= 10 ->
              {:halt, {true, pos}}

            true ->
              {:cont, {false, pos}}
          end

        _ ->
          {:cont, {false, pos}}
      end
    end)
  end

  defp split_number(sf) do
    {is_greater_ten, pos} = find_greater_ten(sf)

    split_number(sf, pos, is_greater_ten)
  end

  defp split_number(sf, _pos, false) do
    sf
  end

  defp split_number(sf, pos, true) do
    val = String.to_integer(Enum.at(sf, pos))

    new_sf =
      sf
      |> List.update_at(pos, fn _ -> "[" end)
      |> List.insert_at(pos + 1, to_string(floor(val / 2)))
      |> List.insert_at(pos + 2, ",")
      |> List.insert_at(pos + 3, to_string(ceil(val / 2)))
      |> List.insert_at(pos + 4, "]")

    # IO.inspect(Enum.join(sf, ""), label: "before splitting", charlists: :as_lists, pretty: true)

    # IO.inspect(Enum.join(new_sf, ""), label: "after splitting", charlists: :as_lists, pretty: true)

    explode(new_sf)
  end

  defp magnitude(sf) do
    magnitude(sf, 0)
  end

  defp magnitude(sf, pairs) do
    mag_list =
      Enum.reduce_while(0..(length(sf) - 5), sf, fn i, acc ->
        cond do
          Enum.at(sf, i) == "[" and Enum.at(sf, i + 4) == "]" ->
            l = String.to_integer(Enum.at(sf, i + 1)) * 3
            r = String.to_integer(Enum.at(sf, i + 3)) * 2
            {:halt, zero_at(sf, i, to_string(l + r))}

          true ->
            {:cont, acc}
        end
      end)

    if length(mag_list) == 1 do
      {String.to_integer(Enum.at(mag_list, 0)), pairs}
    else
      magnitude(mag_list, pairs + 1)
    end
  end
end
