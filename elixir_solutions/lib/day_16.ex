defmodule Day16 do
  @valve_report ~r/Valve (?<valve>[A-Z]{2}) has flow rate=(?<rate>\d+); tunnel(s)? lead(s)? to valve(s)? (?<edges>.+)/

  def run(path \\ "assets/d16full.txt") do
    input = parse_input(path)

    {solution_1(input), solution_2(input)}
  end

  def parse_input(path) do
    init_graph =
      File.read!(path)
      |> String.split("\n", trim: true)
      |> Enum.reduce(%{}, fn line, map ->
        %{"valve" => valve, "rate" => rate, "edges" => edges} =
          Regex.named_captures(@valve_report, line)

        Map.put(map, valve, %{
          rate: String.to_integer(rate),
          edges: String.split(edges, ", ", trim: true) |> MapSet.new()
        })
      end)

    for {node, %{rate: rate, edges: edges}} <- init_graph,
        {edge, %{rate: e_rate}} <- init_graph,
        node != edge,
        reduce: %{} do
      acc ->
        case get_in(acc, [node, :edges, edge]) do
          nil ->
            distance = shortest_distance(node, edge, init_graph, edges)
            mutual_update(acc, node, edge, {rate, e_rate}, distance)

          _ ->
            acc
        end
    end
  end

  defp mutual_update(map, node, edge, {n_rate, e_rate}, distance) do
    Map.update(map, node, %{rate: n_rate, edges: %{}}, fn n_map ->
      Map.update(n_map, :edges, %{}, &Map.put(&1, edge, distance))
    end)
    |> Map.update(edge, %{rate: e_rate, edges: %{}}, fn e_map ->
      Map.update(e_map, :edges, %{}, &Map.put(&1, node, distance))
    end)
  end

  defp shortest_distance(node, target, graph, visited, depth \\ 1)

  defp shortest_distance(node, target, graph, visited, depth) do
    if MapSet.member?(visited, target) do
      depth
    else
      shortest_distance(
        node,
        target,
        graph,
        Enum.reduce(visited, visited, &MapSet.union(&2, graph[&1][:edges])),
        depth + 1
      )
    end
  end

  defp maybe_dec(nil), do: nil
  defp maybe_dec(x), do: x - 1

  def permutations(list, node, graph, budget, max_len \\ nil)
  def permutations(_, _, _, _, 0), do: [[]]
  def permutations(_, _, _, budget, _) when budget <= 1, do: [[]]
  def permutations([], _, _, _, _), do: [[]]

  def permutations(list, node, graph, budget, max_len) do
    for edge <- list,
        cost = graph[node][:edges][edge],
        budget - cost - 1 >= 0,
        tail <- permutations(list -- [edge], edge, graph, budget - cost - 1, maybe_dec(max_len)),
        do: [edge | tail]
  end

  def traverse_trail(graph, start, trail, time_limit) do
    {_, relief, rps, time_remaining} =
      Enum.reduce(trail, {start, 0, 0, time_limit}, fn node, {current, relief, rps, budget} ->
        cost = graph[current][:edges][node] + 1
        relief = relief + cost * rps
        rps = rps + graph[node][:rate]

        {node, relief, rps, budget - cost}
      end)

    relief + rps * time_remaining
  end

  def solution_1(graph, start \\ "AA") do
    Enum.reduce(graph, [], fn
      {_, %{rate: 0}}, acc -> acc
      {node, _}, acc -> [node | acc]
    end)
    |> permutations(start, graph, 30)
    |> Enum.map(&traverse_trail(graph, start, &1, 30))
    |> Enum.max()
  end

  def solution_2(graph, start \\ "AA") do
    non_zero_nodes =
      Enum.reduce(graph, [], fn
        {_, %{rate: 0}}, acc -> acc
        {node, _}, acc -> [node | acc]
      end)

    permutations = permutations(non_zero_nodes, start, graph, 26)

    max_len = permutations |> Enum.max_by(&length/1) |> length

    permutations =
      Enum.reduce(max_len..1, permutations, fn len, acc ->
        permutations(non_zero_nodes, start, graph, 26, len) ++ acc
      end)

    best_scores =
      Enum.reduce(permutations, %{}, fn trail, acc ->
        score = traverse_trail(graph, start, trail, 26)
        Map.update(acc, MapSet.new(trail), score, &max(score, &1))
      end)

    for {my_path, my_score} <- best_scores,
        {el_path, el_score} <- best_scores,
        MapSet.disjoint?(my_path, el_path),
        reduce: 0 do
      acc -> max(acc, my_score + el_score)
    end
  end
end
