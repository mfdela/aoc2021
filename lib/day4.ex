defmodule Aoc2021.Day4 do
  def run(part) do
    # If not passed any argument then
    # load the input file
    File.read!("inputs/day4_input.txt")
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
    [n | b] =
      input
      |> String.split("\n", trim: true)

    numbers =
      n
      |> String.split(",", trim: true)
      |> Enum.map(&String.to_integer/1)

    board_lists =
      b
      |> Enum.map(fn l -> l |> String.split(" ", trim: true) |> Enum.map(&String.to_integer/1) end)

    [first_row_board | _] = board_lists
    size_board = length(first_row_board)
    boards = Enum.chunk_every(board_lists, size_board)
    # boards is a list of list of lists
    # each inner list is a row of the board
    # [
    #   [
    #     [22, 13, 17, 11, 0],
    #     [8, 2, 23, 4, 24],
    #     [21, 9, 14, 16, 7],
    #     [6, 10, 3, 18, 5],
    #     [1, 12, 20, 15, 19]
    #   ],
    #   [
    #     [ ... ]
    #   ]
    # ]

    {numbers, boards, size_board, length(boards)}
  end

  defp main(input, part) do
    {numbers, boards, size_board, num_boards} = input
    # for each winning number
    {_, _, first_winning_board, last_winning_board, first_winning_number, last_winning_number} =
      Enum.reduce(numbers, {boards, [], [], [], 0, 0}, fn n,
                                                          {all_boards, boards_to_remove, fwb, lwb,
                                                           fwn, lwn} ->
        # check number n and substitute with -1 in all boards
        checked_boards = check_number(n, all_boards)
        # IO.inspect(checked_boards)
        # for each board
        {all_boards_n, boards_to_remove_n, fwb_n, lwb_n, fwn_n, lwn_n} =
          Enum.reduce(
            0..(num_boards - 1),
            {checked_boards, boards_to_remove, fwb, lwb, fwn, lwn},
            fn i, {all_boards_i, btr_i, fwb_i, lwb_i, fwn_i, lwn_i} ->
              board_i = Enum.at(all_boards_i, i)

              if not Enum.any?(btr_i, fn k -> k == i end) and
                   is_winning_board?(board_i, size_board) do
                if Enum.empty?(fwb_i) do
                  {all_boards_i, btr_i ++ [i], board_i, board_i, n, n}
                else
                  {all_boards_i, btr_i ++ [i], fwb_i, board_i, fwn_i, n}
                end
              else
                {all_boards_i, btr_i, fwb_i, lwb_i, fwn_i, lwn_i}
              end
            end
          )

        {all_boards_n, boards_to_remove_n, fwb_n, lwb_n, fwn_n, lwn_n}
      end)

    case part do
      :part1 ->
        first_winning_number * sum_board(first_winning_board)

      :part2 ->
        last_winning_number * sum_board(last_winning_board)
    end
  end

  defp check_number(n, boards) do
    # return a new list of boards
    # where the number n is substituted with -1
    boards
    |> Enum.map(fn board ->
      Enum.map(board, fn row ->
        Enum.map(row, fn m ->
          cond do
            m == n -> -1
            true -> m
          end
        end)
      end)
    end)
  end

  defp is_winning_board?(board, size_board) do
    row_of_1 = List.duplicate(-1, size_board)
    row = Enum.find_index(board, fn r -> r === row_of_1 end)
    col = Enum.find_index(transpose(board), fn r -> r === row_of_1 end)

    cond do
      is_integer(row) or is_integer(col) -> true
      true -> false
    end
  end

  defp sum_board(board) do
    Enum.reduce(board, 0, fn row, sum ->
      sum + Enum.sum(Enum.filter(row, fn n -> n != -1 end))
    end)
  end

  defp transpose(rows) do
    rows
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
  end
end
