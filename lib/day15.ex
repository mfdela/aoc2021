defmodule Aoc2021.Day15 do
  def run(part) do
    # If not passed any argument then
    # load the input file
    {g, m, r, c} =
      File.read!("inputs/day15_input.txt")
      |> parse_input(part)

    main(g, m, r, c)
  end

  def run(part, test_input) do
    # If passed the input as an argument then use it
    {g, m, r, c} =
      test_input
      |> parse_input(part)

    main(g, m, r, c)
  end

  defp parse_input(input, part) do
    # treat the input matrix as a directed graph, where you can
    # travel only down or to the right

    input_values =
      String.split(input, "\n", trim: true)
      |> Enum.map(fn row ->
        Enum.map(String.split(row, "", trim: true), fn val -> String.to_integer(val) end)
      end)

    values =
      case part do
        :part1 ->
          input_values

        :part2 ->
          r = length(input_values)
          # c = length(Enum.at(input_values, 0))

          out_1_5 =
            for y <- 1..4, reduce: input_values do
              out_y ->
                for r_i <- 0..(r - 1), reduce: out_y do
                  out_1 ->
                    new_row =
                      Enum.map(Enum.at(input_values, r_i), fn v ->
                        if v + y > 9 do
                          v + y - 9
                        else
                          v + y
                        end
                      end)

                    List.update_at(out_1, r_i, fn _ ->
                      List.wrap(Enum.at(out_y, r_i)) ++ new_row
                    end)
                end
            end

          for x <- 1..4, reduce: out_1_5 do
            out_x ->
              for r_i <- 0..(r - 1), reduce: out_x do
                out_5 ->
                  new_row =
                    Enum.map(Enum.at(out_5, r_i), fn v ->
                      if v + x > 9 do
                        v + x - 9
                      else
                        v + x
                      end
                    end)

                  out_5 ++ [new_row]
              end
          end
      end

    rows = length(values)
    columns = length(Enum.at(values, 0))

    vertices =
      values
      |> Enum.with_index()
      |> Enum.reduce([], fn {row, r}, vl ->
        Enum.with_index(row)
        |> Enum.reduce(vl, fn {_val, c}, vert ->
          [{r, c} | vert]
        end)
      end)

    edges =
      for r <- 0..(rows - 1), c <- 0..(columns - 1), reduce: [] do
        acc ->
          v = {r, c}

          e1 =
            if r < rows - 1 do
              Graph.Edge.new(v, {r + 1, c}, weight: Enum.at(Enum.at(values, r + 1), c))
            end

          e2 =
            if c < columns - 1 do
              Graph.Edge.new(v, {r, c + 1}, weight: Enum.at(Enum.at(values, r), c + 1))
            end

          e3 =
            if(r > 1) do
              Graph.Edge.new(v, {r - 1, c}, weight: Enum.at(Enum.at(values, r - 1), c))
            end

          e4 =
            if(c > 1) do
              Graph.Edge.new(v, {r, c - 1}, weight: Enum.at(Enum.at(values, r), c - 1))
            end

          [e1, e2, e3, e4 | acc]
      end
      |> Enum.reject(&is_nil/1)

    graph =
      Graph.new()
      |> Graph.add_vertices(vertices)
      |> Graph.add_edges(edges)

    # https://github.com/bitwalker/libgraph/issues/44
    fail =
      graph
      |> Graph.edges()
      |> Enum.filter(fn %Graph.Edge{v1: {x1, y1}, v2: {x2, y2}} ->
        abs(x1 - x2) > 1 and abs(y1 - y2) > 1
      end)

    {Graph.delete_edges(graph, fail), values, rows, columns}
  end

  defp main(graph, matrix, r, c) do
    IO.inspect(Graph.info(graph))

    min_path = Graph.dijkstra(graph, {0, 0}, {r - 1, c - 1})

    Enum.reduce(min_path, 0, fn v, sum ->
      {r, c} = v
      sum + Enum.at(Enum.at(matrix, r), c)
    end) - Enum.at(Enum.at(matrix, 0), 0)
  end
end
