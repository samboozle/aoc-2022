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
    traverse_map(height_map, [beg], MapSet.new([beg]), &MapSet.member?(&1, fin))
  end

  def solution_2({height_map, _, fin}) do
    traverse_map(
      height_map,
      [fin],
      MapSet.new([fin]),
      &Enum.any?(&1, fn {x, y} -> get_in(height_map, [x, y]) == ?a end),
      :desc
    )
  end

  defp traverse_map(map, queue, seen, destination, dir \\ :asc, depth \\ 0, done \\ false)
  defp traverse_map(_, _, _, _, _, depth, true), do: depth - 1

  defp traverse_map(map, queue, seen, testfn, dir, depth, _) do
    {queue, seen} =
      Enum.reduce(queue, {[], seen}, fn node, {q, s} ->
        {Enum.uniq(neighbors(node, map, s, dir) ++ q), MapSet.put(s, node)}
      end)

    traverse_map(map, queue, seen, testfn, dir, depth + 1, testfn.(seen))
  end

  defp neighbors(node = {x, y}, map, seen, dir) do
    [{x, y - 1}, {x, y + 1}, {x - 1, y}, {x + 1, y}]
    |> Stream.filter(&(not MapSet.member?(seen, &1)))
    |> Enum.filter(fn {a, b} -> not is_nil(get_in(map, [a, b])) end)
    |> neighbor_filter(node, map, dir)
  end

  defp neighbor_filter(neighs, {x, y}, map, :asc) do
    Enum.filter(neighs, fn {a, b} ->
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

  defp neighbor_filter(neighs, {x, y}, map, :desc) do
    Enum.filter(neighs, fn {a, b} ->
      case {get_in(map, [a, b]), get_in(map, [x, y])} do
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
