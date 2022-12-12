defmodule Day12 do
  def run(path \\ "assets/d12full.txt") do
    input = parse_input(path)
    {solution_1(input), solution_2(input)}
  end

  def parse_input(path) do
    height_map =
      File.read!(path)
      |> String.split("\n", trim: true)
      |> Enum.map(&String.to_charlist/1)

    {height_map, beg, fin} =
      Enum.with_index(height_map)
      |> Enum.reduce({%{}, nil, nil}, fn {line, row}, {map, beg, fin} ->
        {
          Map.put(map, row, Enum.with_index(line) |> Map.new(fn {a, b} -> {b, a} end)),
          case Enum.find_index(line, &(&1 == ?S)) do
            nil -> beg
            idx -> {row, idx}
          end,
          case Enum.find_index(line, &(&1 == ?E)) do
            nil -> fin
            idx -> {row, idx}
          end
        }
      end)

    {height_map, beg, fin}
  end

  def solution_1({height_map, beg, fin}) do
    traverse_map(height_map, [beg], MapSet.new([beg]), fin)
  end

  def solution_2(input) do
    solution_1(input)
  end

  defp traverse_map(map, queue, seen, destination, depth \\ 0, done \\ false)
  defp traverse_map(_, _, _, _, depth, true), do: depth - 1

  defp traverse_map(map, queue, seen, destination, depth, _) do
    {queue, seen} =
      Enum.reduce(queue, {[], seen}, fn node, {q, s} ->
        {Enum.uniq(neighbors(node, map, s) ++ q), MapSet.put(s, node)}
      end)

    traverse_map(map, queue, seen, destination, depth + 1, MapSet.member?(seen, destination))
  end

  defp neighbors({x, y}, map, seen) do
    [{x, y - 1}, {x, y + 1}, {x - 1, y}, {x + 1, y}]
    |> Stream.filter(&(not MapSet.member?(seen, &1)))
    |> Enum.filter(fn {a, b} -> not is_nil(get_in(map, [a, b])) end)
    |> Enum.filter(fn {a, b} ->
      case {get_in(map, [x, y]), get_in(map, [a, b])} do
        {?S, ?a} -> true
        {?S, ?b} -> true
        {?y, ?E} -> true
        {?z, ?E} -> true
        {_, ?E} -> false
        {here, there} -> there <= here + 1
      end
    end)
  end
end
