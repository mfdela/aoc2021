defmodule Aoc2021.Day12 do
  def run(part) do
    # If not passed any argument then
    # load the input file
    {v, g} =
      File.read!("inputs/day12_input.txt")
      |> parse_input()

    main(v, g, part)
  end

  def run(part, test_input) do
    # If passed the input as an argument then use it
    {v, g} =
      test_input
      |> parse_input()

    main(v, g, part)
  end

  defp parse_input(input) do
    strings =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, "-", trim: true))

    g = :digraph.new()

    vertices =
      strings
      |> List.flatten()
      |> Enum.uniq()
      |> Enum.reduce(%{}, fn label, vmap ->
        vertex = :digraph.add_vertex(g)
        v = :digraph.add_vertex(g, vertex, label)
        Map.put(vmap, label, v)
      end)

    strings
    |> Enum.each(fn [v1, v2] ->
      vertex1 = vertices[v1]
      vertex2 = vertices[v2]

      cond do
        v1 == "start" or v2 == "end" ->
          :digraph.add_edge(g, vertex1, vertex2)

        v2 == "start" or v1 == "end" ->
          :digraph.add_edge(g, vertex2, vertex1)

        true ->
          :digraph.add_edge(g, vertex1, vertex2)
          :digraph.add_edge(g, vertex2, vertex1)
      end
    end)

    {vertices, g}
  end

  defp main(vertices, graph, part) do
    vertices_to_label = Enum.reduce(vertices, %{}, fn {k, v}, map -> Map.put(map, v, k) end)
    {paths, _, _} = find_paths(part, graph, vertices, vertices_to_label, "start", "end")
    length(paths)
  end

  defp find_paths(part, g, v, vl, s, d) do
    visited = Enum.reduce(v, %{}, fn {k, _v}, map -> Map.put(map, k, 0) end)
    find_paths(part, g, v, vl, s, d, visited, [], [])
  end

  defp find_paths(_part, _g, _vertices, _vertices_inverse, s, d, visited, all_paths, current_path)
       when s == d do
    {all_paths ++ [current_path ++ [d]], current_path, visited}
  end

  defp find_paths(part, g, vertices, vertices_inverse, s, d, visited, all_paths, current_path) do
    now_visited = Map.update(visited, s, 1, fn v -> v + 1 end)
    local_path = current_path ++ [s]

    {rap, rcp, rvisiting} =
      Enum.reduce(
        :digraph.out_neighbours(g, vertices[s]),
        {all_paths, local_path, now_visited},
        fn vertex, {ap, cp, visiting} ->
          v = vertices_inverse[vertex]

          if(not_visited_yet?(part, v, visiting)) do
            find_paths(part, g, vertices, vertices_inverse, v, d, visiting, ap, cp)
          else
            {ap, cp, visiting}
          end
        end
      )

    last_visited = Map.update!(rvisiting, s, fn v -> v - 1 end)

    last_path =
      cond do
        is_list(rcp) ->
          List.delete_at(rcp, length(rcp) - 1)

        true ->
          [rcp]
      end

    {rap, last_path, last_visited}
  end

  defp not_visited_yet?(part, v, visited) do
    case part do
      :part1 ->
        String.upcase(v) == v or not (visited[v] > 0)

      :part2 ->
        count =
          Enum.reduce(visited, 0, fn {k, v}, c ->
            if String.upcase(k) != k and v > 1 do
              c + 1
            else
              c
            end
          end)

        cond do
          String.upcase(v) == v -> true
          visited[v] >= 1 and count >= 1 -> false
          visited[v] > 2 -> false
          true -> true
        end
    end
  end
end