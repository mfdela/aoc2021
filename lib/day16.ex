defmodule Aoc2021.Day16 do
  # most code borrowed from
  # https://github.com/bjorng/advent-of-code-2021/blob/daf1e4875a4a61eccc2610406bb08d85f72fa189/day16/lib/day16.ex
  # bit string manipulation is boring

  def run(part) do
    # If not passed any argument then
    # load the input file
    File.read!("inputs/day16_input.txt")
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
    int = String.to_integer(String.trim(input), 16)
    size_b = byte_size(input) - 1
    <<int::integer-size(size_b)-unit(4)>>
  end

  defp main(input, part) do
    {packets, _} = decode_packet(input)

    case part do
      :part1 -> version_sum(packets, 0)
      :part2 -> compute_packet(packets)
    end
  end

  defp decode_packet(input) do
    case input do
      <<version::size(3), id::size(3), body::bitstring>> ->
        case id do
          4 ->
            {literal, body} = decode_literal(body)
            {{version, :literal, literal}, body}

          _ ->
            {packets, body} = decode_operator(body)
            {{version, id, packets}, body}
        end

      _ ->
        {:none, input}
    end
  end

  defp decode_literal(bitstring, acc \\ 0) do
    case bitstring do
      <<last::size(1), n::size(4), body::bitstring>> ->
        acc = acc * 16 + n

        case last do
          0 -> {acc, body}
          1 -> decode_literal(body, acc)
        end
    end
  end

  defp decode_operator(bitstring) do
    case bitstring do
      <<0::size(1), total_size::size(15), body::bitstring>> ->
        <<packets::bitstring-size(total_size), body::bitstring>> = body
        {packets, <<>>} = decode_packets(packets, [])
        {packets, body}

      <<1::size(1), num_packets::size(11), body::bitstring>> ->
        decode_n_packets(body, num_packets, [])
    end
  end

  defp decode_packets(bitstring, acc) do
    case decode_packet(bitstring) do
      {:none, tail} ->
        {acc, tail}

      {packet, tail} ->
        decode_packets(tail, acc ++ [packet])
    end
  end

  defp decode_n_packets(bitstring, 0, acc) do
    {acc, bitstring}
  end

  defp decode_n_packets(bitstring, num_packets, acc) do
    {packet, tail} = decode_packet(bitstring)
    decode_n_packets(tail, num_packets - 1, acc ++ [packet])
  end

  defp version_sum({version, :literal, _}, sum) do
    sum + version
  end

  defp version_sum({version, _, packets}, sum) do
    Enum.reduce(packets, sum + version, &version_sum/2)
  end

  defp compute_packet({_, :literal, value}) do
    value
  end

  defp compute_packet({_, id, arguments}) do
    arguments = Enum.map(arguments, &compute_packet/1)

    case id do
      0 ->
        Enum.sum(arguments)

      1 ->
        Enum.reduce(arguments, 1, &*/2)

      2 ->
        Enum.min(arguments)

      3 ->
        Enum.max(arguments)

      5 ->
        [first, second] = arguments
        if first > second, do: 1, else: 0

      6 ->
        [first, second] = arguments
        if first < second, do: 1, else: 0

      7 ->
        [first, second] = arguments
        if first == second, do: 1, else: 0
    end
  end
end
